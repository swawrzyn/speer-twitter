class Api::V1::UserController < ApplicationController
  before_action :authenticate_user

  api :GET, '/v1/user/me'
  description "User Information"
  returns code: 200 do
    property :data, Hash do
      property :id, String
      property :type, String
      property :attributes, Hash do
        property :username, String
      end
    end
  end
  def me
    render json: UserSerializer.new(current_user), status: 200
  end

  api :GET, '/v1/user/tweets'
  description "Get all user tweets"
  returns code: 200 do
    property :data, Hash do
      property :id, String
      property :type, String
      property :attributes, Hash do
        property :content, String
        property :like_count, String
      end
    end
  end
  def tweets
    @tweets = Tweet.where(user: current_user)

    render json: TweetSerializer.new(@tweets), status: 200
  end

  api :GET, '/v1/user/likes'
  description "Get all user likes"
  returns code: 200 do
    property :data, Hash do
      property :id, String
      property :type, String
      property :attributes, Hash do
        property :content, String
        property :like_count, String
      end
      property :relationships, Hash do
        property :id, String
        property :type, String
      end
      property :included, Hash do
        property :id, String
        property :type, String
        property :attributes, Hash
      end
    end
  end
  def likes
    @likes = Like.where(user: current_user)

    render json: LikeSerializer.new(@likes, include: %i[user tweet])
  end
end
