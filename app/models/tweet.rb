# == Schema Information
#
# Table name: tweets
#
#  id         :integer          not null, primary key
#  content    :string
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  like_count :integer          default("0")
#
# Indexes
#
#  index_tweets_on_user_id  (user_id)
#

class Tweet < ApplicationRecord
  belongs_to :user
  has_many :likes

  validates :content, presence: true, length: { maximum: 280 }
end
