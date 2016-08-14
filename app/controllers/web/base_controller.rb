module Web
  class BaseController < ApplicationController
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    helper_method :current_user

    def authorize
      redirect_to new_sessions_path unless current_user
    end

    def already_authenticated
      redirect_to root_path, flash: {alert: t('auth.failure.already_authenticated')} if current_user
    end
  end
end
