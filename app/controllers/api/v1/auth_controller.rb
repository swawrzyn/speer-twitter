class Api::V1::AuthController < ApplicationController
  
  api :POST, '/v1/auth', 'User Login'
  description "User Login"
  param :credentials, Hash, required: true do
    param :username, String, required: true
    param :password, String, required: true
  end
  example " {'credentials': {'username': 'testuser', 'password': '1Testpassword!'}} "
  returns code: 200, desc: "Login successful" do
    property :data, Hash do
      property :id, Integer
      property :type, String
      property :attributes, Hash do
        property :username, String
      end
    end
  end
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

  api :DELETE, '/v1/auth', 'User Logout'
  description "User Logout"
  returns code: 204
  def delete
    session.clear
    head :no_content
  end

  api :POST, '/v1/auth/register', 'User Registration'
  description "User Registration"
  param :credentials, Hash, required: true do
    param :username, String, required: true
    param :password, String, required: true
  end
  example " {'credentials': {'username': 'testuser', 'password': '1Testpassword!'}} "
  returns code: 201
  error code: 422, desc: "Validation Error" do
    property :message, String, desc: "Error type"
    property :errors, Hash, desc: "Hash of the invalid keys and reasons."
  end
  def register
    @user = User.new(auth_params)

    if @user.save
      head :created
    else
      render json: { message: "validation_failed", errors: @user.errors }, status: 422
    end
  end

  private

  def auth_params
    params.require(:credentials).permit(:username, :password)
  end
end
