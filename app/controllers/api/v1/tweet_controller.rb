class Api::V1::TweetController < ApplicationController
  before_action :authenticate_user,
                only: %i[create update destroy like retweet thread]

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
    end
    property :included, Array do
      property :id, String
      property :type, String
      property :attributes, Hash
    end
  end

  api :GET, '/v1/tweet', 'Get all tweets'
  description 'Get all tweets'
  returns array_of: :tweet, code: 200, desc: 'All tweets'
  def index
    options = {}
    options[:include] = %i[user retweet_parent]

    @tweets = Tweet.includes(options[:include]).all

    render json: TweetSerializer.new(@tweets, options)
  end

  api :GET, '/v1/tweet/:id', 'Get a single tweet'
  description 'Gets a single tweet'
  returns :tweet, desc: 'A single tweet'
  def show
    options = {}
    options[:include] = %i[user retweet_parent tweet_thread]

    @tweet = Tweet.includes(options[:include]).find(params[:id])

    render json:
             TweetSerializer.new(
               @tweet,
               include: [
                 :user,
                 :retweet_parent,
                 :tweet_thread,
                 :'tweet_thread.tweets',
               ],
             )
  end

  api :POST, '/v1/tweet', 'Create a tweet'
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

  api :PATCH, '/v1/tweet/:id', 'Update a tweet'
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

  api :DELETE, '/v1/tweet/:id', 'Delete a tweet'
  description 'Delete a tweet'
  returns code: 204
  def destroy
    @tweet = Tweet.find(params[:id])

    if @tweet.user != current_user
      render json: { message: 'not_authorized' }, status: 401
    else
      head :no_content if @tweet.destroy
    end
  end

  api :PUT, '/v1/tweet/:id/like', 'Like/un-like a tweet'
  description 'Like/unlike a tweet'
  returns code: 204
  def like
    tweet = Tweet.find(params[:id])

    @like = Like.find_or_initialize_by(user: current_user, tweet: tweet)

    if @like.id
      @like.destroy
      head :no_content
    elsif @like.save
      render json: LikeSerializer.new(@like, include: %i[user tweet]),
             status: 200
    end
  end

  api :POST, '/v1/tweet/:id/retweet', 'Retweet a tweet'
  description 'Retweet a tweet'
  returns :tweet, desc: 'The retweet'
  def retweet
    tweet = Tweet.find(params[:id])

    @retweet = Tweet.new(tweet_params)

    @retweet.retweet_parent = tweet
    @retweet.user = current_user

    if @retweet.save
      render json:
               TweetSerializer.new(@retweet, include: %i[user retweet_parent]),
             status: 201
    else
      render json: {
               message: 'validation_failed',
               errors: @retweet.errors,
             },
             status: 422
    end
  end

  api :POST, '/v1/tweet/thread', 'Create a tweet thread'
  param :thread, Hash, desc: 'Thread payload' do
    property :content,
             Array,
             desc:
               'an array of tweet contents, eg. ["abc", "def", "ghi"] will create three tweets in the thread.'
             
  end
  returns code: 201, desc: 'successful response' do
    property :data, Hash do
      property :id, String
      property :type, String
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
      property :attributes, Hash
    end
  end
  def thread
    # need to use begin/rescue block for rollback support
    begin
      @thread = TweetThread.create!(user: current_user)
      for content in thread_params[:content]
        Tweet.create(
          user: current_user,
          content: content,
          tweet_thread: @thread,
        )
      end

      render json:
               TweetThreadSerializer.new(
                 @thread,
                 include: %i[tweets tweets.user],
               ),
             status: 201
    rescue ActiveRecord::RecordInvalid => invalid
      render json: {
               message: 'validation_failed',
               errors: invalid.errors,
             },
             status: 422
    end
  end

  private

  def tweet_params
    params.require(:tweet).permit(:content)
  end

  def thread_params
    params.require(:thread).permit(content: [])
  end
end
