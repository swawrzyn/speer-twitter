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

require 'rails_helper'

RSpec.describe Tweet, type: :model do
  context 'validations' do
    let(:user) { create(:user) }

    it 'content has max 280 chars' do
      content =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in volupta.'
  
      tweet = Tweet.new(user: user, content: content)

      tweet.validate

      expect(tweet.errors[:content]).to include("is too long (maximum is 280 characters)")
    end

    it 'validates presence of content' do
      content = " "

      tweet = Tweet.new(user: user, content: content)

      tweet.validate

      expect(tweet.errors[:content]).to include("can't be blank")
    end

    it 'requires user' do
      content = "test content"

      tweet = Tweet.new(content: content)

      tweet.validate

      expect(tweet.errors[:user]).to include("must exist")
    end
  end
end
