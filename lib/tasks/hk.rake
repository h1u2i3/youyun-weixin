namespace :hk do
  desc "Mina deploy"
  task :dp, [:m] do |t, args|
    puts 'add all change file to git ...'
    `git add -A`
    puts 'finish add all changed file.'
    puts 'add commit to git ...'
    cmd = "git commit -m '#{args.m}'"
    `#{cmd}`
    puts 'finish add commit to git.'
    puts 'push to remote ...'
    `git push`
    puts 'finish push to remote.'
    puts 'deploy to hongkong vps ...'
    `mina deploy`
    puts 'finish deploy to hongkong vps.'
  end

end
