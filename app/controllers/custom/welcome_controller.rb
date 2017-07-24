require_dependency Rails.root.join('app', 'controllers', 'welcome_controller').to_s

class WelcomeController < ApplicationController

  def index

  end

  def countdown
    render :layout => false
  end

end