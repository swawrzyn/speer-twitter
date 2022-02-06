class TweetSerializer
  include JSONAPI::Serializer
  belongs_to :user
  attributes :content, :like_count
end
