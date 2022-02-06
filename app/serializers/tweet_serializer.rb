class TweetSerializer
  include JSONAPI::Serializer
  belongs_to :user
  belongs_to :retweet_parent, serializer: :tweet

  belongs_to :tweet_thread

  attributes :content, :like_count, :retweet_count, :created_at
end
