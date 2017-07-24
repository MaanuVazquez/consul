require_dependency Rails.root.join('app', 'controllers', 'management/users_controller').to_s

class Management::UsersController < Management::BaseController

  def new
    if params[:user].nil?
      @user = User.new
    else
      @user = User.new(user_params)
    end
  end

  def create
    @user = User.new(user_params)
    @user.skip_password_validation = true
    @user.terms_of_service = '1'
    @user.residence_verified_at = Time.current
    @user.verified_at = Time.current

    if @user.save then
      render :show
    else
      render :new
    end
  end

  private

    def destroy_session
      session[:document_type] = nil
      session[:document_number] = nil
      session[:email] = nil
    end

end
