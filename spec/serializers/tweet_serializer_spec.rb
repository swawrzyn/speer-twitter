require 'rails_helper'

RSpec.describe 'TweetSerializer' do
  context 'results' do
    let(:tweet) { create(:tweet) }
    let!(:likes) { create_list(:like, 20, tweet: tweet) }

    it 'returns number of likes' do
      res = TweetSerializer.new(tweet).serializable_hash
      expect(res[:data][:attributes][:like_count]).to eq(20)
    end
  end
end
