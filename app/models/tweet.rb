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

class Tweet < ApplicationRecord
  belongs_to :user
  validates :content, presence: true, length: { maximum: 280 }
end
