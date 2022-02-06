class ApplicationController < ActionController::API
  include ActionController::Cookies

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def not_found
    render json: { message: 'not_found' }, status: :not_found
  end

  def current_user
    @user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !current_user.nil?
  end

  def authenticate_user
    render json: { message: 'not_authorized' }, status: 401 unless logged_in?
  end
end
