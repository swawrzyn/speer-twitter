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
#  tweet_thread_id   :integer
#
# Indexes
#
#  index_tweets_on_retweet_parent_id  (retweet_parent_id)
#  index_tweets_on_tweet_thread_id    (tweet_thread_id)
#  index_tweets_on_user_id            (user_id)
#

class Tweet < ApplicationRecord
  belongs_to :user
  has_many :likes
  belongs_to :retweet_parent, class_name: 'Tweet', optional: true
  has_many :retweets, class_name: 'Tweet', foreign_key: 'retweet_parent_id'

  belongs_to :tweet_thread, optional: true

  has_many :sibling_tweets, through: :tweet_thread, source: 'tweets'

  validates :content, presence: true, length: { maximum: 280 }

  after_create :increment_tweet_retweet_count
  before_destroy :decrement_tweet_retweet_count

  def is_retweet?
    !!self.retweet_parent
  end

  private

  def increment_tweet_retweet_count
    self.retweet_parent.increment!(:retweet_count) if self.retweet_parent
  end

  def decrement_tweet_retweet_count
    self.retweet_parent.decrement!(:retweet_count) if self.retweet_parent
  end
end
