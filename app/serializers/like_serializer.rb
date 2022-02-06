class LikeSerializer
  include JSONAPI::Serializer
  belongs_to :user
  belongs_to :tweet
end
