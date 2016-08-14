class UsersController < ApplicationController
  skip_before_action :authorize, only: [:new, :create]

  def new
    return redirect_to root_path, flash: { success: t('auth.failure.already_authenticated') } if current_user
    @user = User.new
  end

  def create
    return redirect_to root_path, flash: { success: t('auth.failure.already_authenticated') } if current_user
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url, flash: { success: t('auth.registrations.signed_up') }
    else
      render :new
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
