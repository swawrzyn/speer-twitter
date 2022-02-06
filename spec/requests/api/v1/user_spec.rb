require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  describe 'GET /api/v1/user/me' do
    context 'while logged in' do
      let(:user) { create(:user) }

      before do
        login(user)
        get '/api/v1/user/me'
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns user info' do
        expect(json['data']['id']).to eq(user.id.to_s)
      end
    end

    context 'not logged in' do
      before { get '/api/v1/user/me' }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET /api/v1/user/tweets' do
    context 'while logged in' do
      let(:user) { create(:user) }
      let!(:tweets) { create_list(:tweet, 5, user: user) }

      before do
        login(user)
        get '/api/v1/user/tweets'
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all user tweets' do
        expect(json['data'].size).to eq(5)
      end
    end

    context 'not logged in' do
      before { get '/api/v1/user/tweets' }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET /api/v1/user/likes' do
    context 'while logged in' do
      let(:user) { create(:user) }
      let!(:likes) { create_list(:like, 6, user: user) }

      before do
        login(user)
        get '/api/v1/user/likes'
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all user likes' do
        expect(json['data'].size).to eq(6)
      end
    end

    context 'not logged in' do
      before { get '/api/v1/user/likes' }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end
end
