require_dependency Rails.root.join('app', 'controllers', 'users/sessions_controller').to_s

class Users::SessionsController < Devise::SessionsController

  prepend_before_action :check_captcha, only: [:create] # Change this to be any actions you want to protect.

  private

    def after_sign_in_path_for(resource)
      if !verifying_via_email? && resource.show_welcome_screen?
        root_path
      else
        super
      end
    end

    # Google reCaptcha
    def check_captcha
      unless verify_recaptcha
        self.resource = resource_class.new sign_in_params
        # respond_with_navigational(resource) { render :new }
        redirect_to new_user_session_path
      end
    end

end
