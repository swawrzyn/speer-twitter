class TweetThreadSerializer
  include JSONAPI::Serializer

  has_many :tweets, serializer: :tweet
  belongs_to :user
end
