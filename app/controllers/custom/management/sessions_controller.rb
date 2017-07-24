require_dependency Rails.root.join('app', 'controllers', 'management/sessions_controller').to_s

class Management::SessionsController < ActionController::Base

  private

    def admin?
      if current_user.try(:administrator?)
        session[:manager] = {login: "admin_user_#{current_user.id}", id: current_user.id}
      end
    end

    def manager?
      if current_user.try(:manager?)
        session[:manager] = {login: "manager_user_#{current_user.id}", id: current_user.id}
      end
    end

end