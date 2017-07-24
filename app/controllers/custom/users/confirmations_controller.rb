require_dependency Rails.root.join('app', 'controllers', 'users/confirmations_controller').to_s

class Users::ConfirmationsController < Devise::ConfirmationsController

  prepend_before_action :check_captcha, only: [:create] # Change this to be any actions you want to protect.

  private

  # Google reCaptcha
  def check_captcha
    unless verify_recaptcha
      self.resource = resource_class.new
      # respond_with_navigational(resource) { render :new }
      redirect_to new_user_confirmation_path
    end
  end

end