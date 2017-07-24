require_dependency Rails.root.join('app', 'controllers', 'organizations/registrations_controller').to_s

class Organizations::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_captcha, only: [:create] # Change this to be any actions you want to protect.

  private

  # Google reCaptcha
  def check_captcha
    unless verify_recaptcha
      self.resource = resource_class.new sign_up_params
      # respond_with_navigational(resource) { render :new}
      redirect_to new_organization_registration_path
    end
  end

end
