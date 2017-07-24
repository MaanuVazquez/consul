require_dependency Rails.root.join('app', 'controllers', 'management/base_controller').to_s

class Management::BaseController < ActionController::Base

  before_action :set_budget_investments_supports

  private

    def check_verified_user(alert_msg)
      Rails.logger.error("\nmanaged_user: \n#{managed_user.inspect}\n")
      # Rails.logger.debug("#{managed_user.confirmed_at.nil?}")
      # Rails.logger.debug("#{managed_user.email.nil?}")
      if managed_user.id == current_manager[:id] or managed_user.id.nil? or managed_user.email.nil?
        # Rails.logger.error("entra acá?")
        redirect_to management_document_verifications_path, alert: alert_msg
      end
    end

    def managed_user
      if session[:document_number].blank?
        @managed_user ||= Verification::Management::ManagedUser.find_user_by_email(session[:email])
      else
        @managed_user ||= Verification::Management::ManagedUser.find(session[:document_type], session[:document_number])
      end
    end

    def set_budget_investments_supports
      @budget_investments_supports = current_user ? current_user.budget_investment_votes(@last_budget_investments) : {}
    end

end
