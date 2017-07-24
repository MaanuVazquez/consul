require_dependency Rails.root.join('app', 'controllers', 'management/document_verifications_controller').to_s

class Management::DocumentVerificationsController < Management::BaseController

  def check
    @document_verification = Verification::Management::Document.new(document_verification_params)
    @document_verification.skip_document_type_validation = true
    @document_verification.skip_document_number_validation = true

    begin
      if @document_verification.valid?
        if @document_verification.verified?
          render :verified
        elsif @document_verification.user?
          render :new
        elsif @document_verification.in_census?
          redirect_to new_management_email_verification_path(email_verification: document_verification_params)
        else
          render :invalid_document
        end
      else
        render :index
      end
    rescue Exception => e
      Rails.logger.debug("Exception:#{e.inspect}")
    end

  end

  private

    def document_verification_params
      params.require(:document_verification).permit(:document_type, :document_number, :email)
    end

    def set_document
      session[:document_type] = params[:document_verification][:document_type]
      session[:document_number] = params[:document_verification][:document_number]
      session[:email] = params[:document_verification][:email]
    end

end