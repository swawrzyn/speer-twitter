require 'rails_helper'

RSpec.describe 'Api::V1::Tweet', type: :request do
  describe 'GET /api/v1/tweet' do
    context do
      let(:user) { create(:user) }
      let!(:tweets) { create_list(:tweet, 5) }

      before { get '/api/v1/tweet' }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all tweets' do
        expect(json['data'].size).to eq(5)
      end
    end
  end

  describe 'GET /api/v1/tweet/:id' do
    context 'tweet exists' do
      let(:tweet) { create(:tweet) }

      before { get "/api/v1/tweet/#{tweet.id}" }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the tweet' do
        expect(json['data']['id']).to eq(tweet.id.to_s)
        expect(json['data']['attributes']['content']).to eq(tweet.content)
      end
    end

    context 'tweet does not exist' do
      before { get '/api/v1/tweet/88888888' }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST /api/v1/tweet' do
    let(:tweet_params) { { tweet: { content: 'This is some test content.' } } }
    context 'while logged in' do
      let(:user) { create(:user) }

      before do
        login(user)
        post '/api/v1/tweet', params: tweet_params
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the tweet' do
        tweet_id = json['data']['id']

        new_tweet = Tweet.find_by(id: tweet_id)

        expect(new_tweet.content).to eq(json['data']['attributes']['content'])
        expect(new_tweet.user_id.to_s).to eq(
          json['data']['relationships']['user']['data']['id'],
        )
      end
    end

    context 'while not logged in' do
      before { post '/api/v1/tweet', params: tweet_params }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'PATCH /api/v1/tweet/:id' do
    let(:tweet_params) { { tweet: { content: 'This is some test content.' } } }
    let(:user) { create(:user) }
    let(:tweet) { create(:tweet, user: user) }

    context 'while tweet owner is user' do
      before do
        login(user)
        patch "/api/v1/tweet/#{tweet.id}", params: tweet_params
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns updated tweet' do
        expect(json['data']['attributes']['content']).to eq(
          tweet_params[:tweet][:content],
        )
      end

      it 'updates successfully' do
        tweet.reload
        expect(tweet.content).to eq(tweet_params[:tweet][:content])
      end
    end

    context 'current user is not tweet owner' do
      let(:other_user) { create(:user) }

      before do
        login(other_user)
        patch "/api/v1/tweet/#{tweet.id}", params: tweet_params
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end

    context 'user not logged in' do
      before { patch "/api/v1/tweet/#{tweet.id}", params: tweet_params }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'DELETE /api/v1/tweet/:id' do
    let(:user) { create(:user) }
    let(:tweet) { create(:tweet, user: user) }

    context 'while tweet owner is user' do
      before do
        login(user)
        delete "/api/v1/tweet/#{tweet.id}"
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'deletes record successfully' do
        expect { tweet.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'while tweet owner is not user' do
      let(:other_user) { create(:user) }
      before do
        login(other_user)
        delete "/api/v1/tweet/#{tweet.id}"
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'does not delete record' do
        tweet.reload
        expect(tweet.id).to be_truthy
      end
    end

    context 'user not logged in' do
      before { delete "/api/v1/tweet/#{tweet.id}" }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'does not delete record' do
        tweet.reload
        expect(tweet.id).to be_truthy
      end
    end
  end

  describe 'PUT /api/v1/tweet/:id/like' do
    let(:user) { create(:user) }
    let(:tweet) { create(:tweet) }

    context 'while logged in, without like already' do
      before do
        login(user)
        put "/api/v1/tweet/#{tweet.id}/like"
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns new like' do
        like = Like.find_by(user: user, tweet: tweet)
        expect(json['data']['id']).to eq(like.id.to_s)
      end
    end

    context 'while logged in, with like already' do
      let!(:like) { create(:like, user: user, tweet: tweet) }

      before do
        login(user)
        put "/api/v1/tweet/#{tweet.id}/like"
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'deletes like' do
        like = Like.find_by(user: user, tweet: tweet)

        expect(like).to eq(nil)
      end
    end

    context 'user not logged in' do
      before { put "/api/v1/tweet/#{tweet.id}/like" }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST /api/v1/retweet' do
    let(:user) { create(:user) }
    let(:tweet) { create(:tweet) }
    let(:retweet_params) { { tweet: { content: 'Test retweet content.' } } }

    context 'while logged in' do
      before do
        login(user)
        post "/api/v1/tweet/#{tweet.id}/retweet", params: retweet_params
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the new tweet' do
        retweet = Tweet.find(json['data']['id'])

        expect(retweet).to be_truthy
      end
    end
  end
end
