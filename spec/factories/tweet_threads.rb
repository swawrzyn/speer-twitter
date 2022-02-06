# == Schema Information
#
# Table name: tweet_threads
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_tweet_threads_on_user_id  (user_id)
#

FactoryBot.define do
  factory :tweet_thread do
    user { build(:user) }

    after(:create) do |thread|
      create_list(:tweet, 5, tweet_thread_id: thread.id, user: thread.user)
    end
  end
end
