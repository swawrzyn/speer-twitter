# == Schema Information
#
# Table name: tweets
#
#  id         :integer          not null, primary key
#  content    :string
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_tweets_on_user_id  (user_id)
#

FactoryBot.define do
  factory :tweet do
    content { "MyString" }
    user { nil }
  end
end
