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

class TweetThread < ApplicationRecord
  belongs_to :user

  has_many :tweets
end
