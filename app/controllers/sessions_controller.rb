class SessionsController < ApplicationController
  skip_before_action :authorize, only: [:new, :create, :destroy]
  before_action :already_authenticated, only: [:new, :create]

  def new
  end

  def create
    user = User.authenticate(user_params[:email], user_params[:password])
    if user
      session[:user_id] = user.id
      redirect_to root_path, flash: { success: t('auth.sessions.signed_in') }
    else
      redirect_to new_session_path, flash: { success: t('auth.failure.invalid', { authentication_keys: :email }) }
    end
  end

  def destroy
    return redirect_to new_session_path, flash: { success: t('auth.failure.unauthenticated') } unless current_user
    session[:user_id] = nil
    redirect_to root_path, flash: { success: t('auth.sessions.signed_out') }
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
