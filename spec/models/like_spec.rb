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

require 'rails_helper'

RSpec.describe Like, type: :model do
  context 'callbacks' do
    let(:tweet) { create(:tweet) }
    let(:user) { create(:user) }

    it 'after create, increase tweet like_count by one' do
      like = Like.create!(user: user, tweet: tweet)

      tweet.reload

      expect(tweet.like_count).to eq(1)
    end

    it 'after delete, decrease tweet like_count by one' do
      like = Like.create!(user: user, tweet: tweet)

      tweet.reload

      expect(tweet.like_count).to eq(1)

      like.destroy

      tweet.reload
      expect(tweet.like_count).to eq(0)
    end
  end
end
