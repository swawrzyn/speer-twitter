class Api::V1::AuthController < ApplicationController
  def create
    @user = User.find_by(username: auth_params[:username])

    if !!@user && @user.authenticate(auth_params[:password])
      session[:user_id] = @user.id
      render json: UserSerializer.new(@user)
    else
      render status: :unauthorized,
             json: {
               errors: ['Bad username or password.'],
             }
    end
  end

  def register
    @user = User.new(auth_params)

    if @user.save
      head :created
    else
      render json: { message: "validation_failed", errors: @user.errors }, status: 422
    end
  end

  def delete
    session.clear
    head :no_content
  end

  private

  def auth_params
    params.require(:credentials).permit(:username, :password)
  end
end
