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

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :tweet

  after_create :increment_tweet_like_count
  before_destroy :decrement_tweet_like_count

  private

  def increment_tweet_like_count
    self.tweet.increment!(:like_count)
  end

  def decrement_tweet_like_count
    self.tweet.decrement!(:like_count)
  end
end
