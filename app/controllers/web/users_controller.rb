module Web
  class UsersController < BaseController
    before_action :already_authenticated, only: [:new, :create]

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        session[:user_id] = @user.id
        redirect_to root_url, flash: {success: t('auth.registrations.signed_up')}
      else
        render :new
      end
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  end
end
