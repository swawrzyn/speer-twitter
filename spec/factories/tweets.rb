# == Schema Information
#
# Table name: tweets
#
#  id                :integer          not null, primary key
#  content           :string
#  user_id           :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  like_count        :integer          default("0")
#  retweet_parent_id :integer
#  retweet_count     :integer          default("0")
#
# Indexes
#
#  index_tweets_on_retweet_parent_id  (retweet_parent_id)
#  index_tweets_on_user_id            (user_id)
#

FactoryBot.define do
  factory :tweet do
    content { Faker::Lorem.paragraph(sentence_count: 2) }
    user { build(:user) }
  end
end
