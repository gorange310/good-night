class ApplicationController < ActionController::API
  ## Auth user by name (replacr auth by token if user registration is active)

  def authenticate_user!
    @user = User.find_by_name(params[:user_name])
  end
end
