# == Schema Information
#
# Table name: likes
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  tweet_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_likes_on_tweet_id  (tweet_id)
#  index_likes_on_user_id   (user_id)
#

FactoryBot.define do
  factory :like do
    user { build(:user) }
    tweet { build(:tweet) }
  end
end
