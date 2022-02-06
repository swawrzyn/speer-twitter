class Api::V1::TweetController < ApplicationController
  before_action :authenticate_user, only: %i[create update destroy]

  def_param_group :tweet do
    property :data, Hash do
      property :id, String
      property :type, String
      property :attributes, Hash do
        property :content, String
      end
      property :relationships, Hash do
        property :user, Hash do
          property :id, String
          property :type, String
        end
      end
      property :included, Array do
        property :id, String
        property :type, String
        property :attributes, Hash do
          property :username, String
        end
      end
    end
  end

  api :GET, '/v1/tweet'
  description 'Get all tweets'
  returns array_of: :tweet, code: 200, desc: 'All tweets'
  def index
    @tweets = Tweet.all

    render json: TweetSerializer.new(@tweets, include: [:user])
  end

  api :GET, '/v1/tweet/:id'
  description 'Gets a single tweet'
  returns :tweet, desc: 'A single tweet'
  def show
    @tweet = Tweet.find(params[:id])


    render json: TweetSerializer.new(@tweet, include: [:user])
  end

  api :POST, '/v1/tweet'
  description 'Create a tweet'
  returns :tweet, desc: 'A single tweet'
  def create
    @tweet = Tweet.new(tweet_params)

    @tweet.user = current_user


    if @tweet.save
      render json: TweetSerializer.new(@tweet, include: [:user]), status: 201
    else
      render json: {
               message: 'validation_failed',
               errors: @tweet.errors,
             },
             status: 422
    end
  end

  api :PATCH, '/v1/tweet/:id'
  description 'Update a tweet'
  returns :tweet, desc: 'The updated tweet'
  def update
    @tweet = Tweet.find(params[:id])

    if @tweet.user != current_user
      render json: { message: 'not_authorized' }, status: 401
    else

      if @tweet.update(tweet_params)
        render json: TweetSerializer.new(@tweet, include: [:user]), status: 200
      else
        render json: {
                 message: 'validation_failed',
                 errors: @tweet.errors,
               },
               status: 422
      end
    end
  end

  api :DELETE, '/v1/tweet/:id'
  description 'Delete a tweet'
  returns code: 204
  def destroy
    @tweet = Tweet.find(params[:id])

    if @tweet.user != current_user
      render json: { message: 'not_authorized' }, status: 401
    else
      head :no_content if @tweet.delete
    end
  end

  private

  def tweet_params
    params.require(:tweet).permit(:content)
  end
end