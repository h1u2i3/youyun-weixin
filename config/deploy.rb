require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/unicorn'
require 'mina/whenever'
require "mina_sidekiq/tasks"

require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
# require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, 'example.com'
set :deploy_to, 'file/path/'
set :repository, 'git://git.example.com'
set :branch, 'master'
set :rails_env, 'production'

# For system-wide RVM install.
#   set :rvm_path, '/usr/local/rvm/bin/rvm'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'config/secrets.yml', 'log', 'config/app_config.yml', 'tmp/sockets', 'tmp/pids']

# Optional settings:
set :user, 'youyun'    # Username in the server to SSH to.
set :port, '22'     # SSH port number.
set :forward_agent, true     # SSH forward_agent.

set :sidekiq_pid, "#{deploy_to}/tmp/pids/sidekiq.pid"
set :unicorn_pid, "#{deploy_to}/tmp/pids/unicorn.pid"

###################
# puma server~!!!!!!
###################

set :puma_pid, -> { "#{deploy_to}/#{shared_path}/pids/puma.pid" }
set :puma_state, -> { "#{deploy_to}/#{shared_path}/pids/puma.state" }
set :app_path, "#{deploy_to}/current"
set :start_puma, %{
  cd #{app_path}
  bundle exec puma --config #{app_path}/config/puma.rb --environment #{rails_env} -d
}

#                                                                    Start task
# ------------------------------------------------------------------------------
desc "Start Puma"
task :'puma_start' => :environment do
  queue 'echo "-----> Start Puma"'
  queue! start_puma
end

#                                                                     Stop task
# ------------------------------------------------------------------------------
desc "Stop Puma"
task :'puma_stop' do
  queue 'echo "-----> Stop Puma"'
  queue! %{
    test -s "#{puma_pid}" && kill -QUIT `cat "#{puma_pid}"` && echo "Stop Ok" && exit 0
    echo >&2 "Not running"
  }
end

desc 'Restart puma'
task puma_restart: :environment do
  invoke :'puma_stop'
  invoke :'puma_start'
end

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use[ruby-1.9.3-p125@default]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/pids"]

  queue! %[mkdir -p "#{deploy_to}/tmp/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/tmp/pids"]


  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/tmp/sockets"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp/sockets"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/tmp/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp/pids"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config"]

  queue! %[touch "#{deploy_to}/#{shared_path}/config/database.yml"]
  queue! %[touch "#{deploy_to}/#{shared_path}/config/secrets.yml"]
  queue! %[touch "#{deploy_to}/#{shared_path}/config/app_config.yml"]

 # for puma
  # queue! %[touch "#{deploy_to}/#{shared_path}/pids/puma.pid"]
  # queue! %[touch "#{deploy_to}/#{shared_path}/pids/puma.state"]
  # queue! %[touch "#{deploy_to}/#{shared_path}/tmp/sockets/pumactl.sock"]
  # queue! %[touch "#{deploy_to}/#{shared_path}/tmp/sockets/puma.sock"]

  queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config/database.yml' and 'secrets.yml'."]

  if repository
    repo_host = repository.split(%r{@|://}).last.split(%r{:|\/}).first
    repo_port = /:([0-9]+)/.match(repository) && /:([0-9]+)/.match(repository)[1] || '22'

    queue %[
      if ! ssh-keygen -H  -F #{repo_host} &>/dev/null; then
        ssh-keyscan -t rsa -p #{repo_port} -H #{repo_host} >> ~/.ssh/known_hosts
      fi
    ]
  end

  # queue %[
  #   repo_host=`echo $repo | sed -e 's/.*@//g' -e 's/:.*//g'` &&
  #   repo_port=`echo $repo | grep -o ':[0-9]*' | sed -e 's/://g'` &&
  #   if [ -z "${repo_port}" ]; then repo_port=22; fi &&
  #   ssh-keyscan -p $repo_port -H $repo_host >> ~/.ssh/known_hosts
  # ]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  to :before_hook do
    # Put things to run locally before ssh
  end
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    to :launch do
      # queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
      # queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
      invoke :'sidekiq:quiet'
      invoke :'sidekiq:restart'
      # invoke :'unicorn:restart'
      invoke :'puma_restart'
      invoke :'whenever:update'
    end
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers
