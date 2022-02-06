module RequestSpecHelper
  def json
    JSON.parse(response.body)
  end

  def login(user)
    user = User.where(:login => user.to_s).first if user.is_a?(Symbol)
    
    post '/api/v1/auth', params: {credentials: {username: user.username, password: 'Password123!'}}
  end

  def current_user
    if !@request.session[:user_id]
      nil
    else
      User.find(@request.session[:user_id])
    end
  end
end
