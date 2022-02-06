class TweetSerializer
  include JSONAPI::Serializer
  belongs_to :user
  belongs_to :retweet_parent, serializer: :tweet

  attributes :content, :like_count, :retweet_count
end
