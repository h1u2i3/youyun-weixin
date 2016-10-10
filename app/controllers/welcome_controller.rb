class WelcomeController < ApplicationController

  def index
  end

  def not_found
    raise PathError
  end

end
