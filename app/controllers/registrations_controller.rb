class RegistrationsController < Devise::RegistrationsController
  skip_before_action :authenticate_user!
  skip_load_and_authorize_resource
  
  private
  def sign_up_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def account_update_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation, :current_password
  end
end
