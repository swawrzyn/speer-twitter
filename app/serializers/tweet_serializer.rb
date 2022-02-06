class TweetSerializer
  include JSONAPI::Serializer
  attributes :content
  belongs_to :user, serializer: UserSerializer
end
