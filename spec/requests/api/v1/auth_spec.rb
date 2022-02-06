require 'rails_helper'

RSpec.describe 'Api::V1::Auth', type: :request do
  describe 'POST /api/v1/auth' do
    let(:user) { create(:user) }

    context 'with valid params' do
      let(:login_params) do
        { credentials: { username: user.username, password: 'Password123!' } }
      end

      before { post '/api/v1/auth', params: login_params }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'has session cookie' do
        expect(response.cookies['_session_id']).to_not be_nil
      end

      it 'has returns user info' do
        expect(json['data']['id']).to eq(user.id.to_s)
        expect(json['data']['attributes']['username']).to eq(user.username)
      end
    end

    context 'without valid params' do
      let(:login_params) do
        {
          credentials: {
            username: 'fakeuser123',
            password: 'testingpassword123',
          },
        }
      end

      before { post '/api/v1/auth', params: login_params }

      it 'returns status code 400' do
        expect(response).to have_http_status(401)
      end

      it 'returns error message' do
        expect(json['errors'][0]).to eq('Bad username or password.')
      end
    end
  end

  describe 'DELETE /api/v1/auth' do
    let(:user) { create(:user) }

    before do
      login(user)
      delete '/api/v1/auth'
    end

    context 'while logged in' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'clears session' do
        expect(current_user).to be_nil
      end
    end
  end

  describe 'POST /api/v1/auth/register' do
    context 'with good params' do
      let(:register_params) do
        { credentials: { username: 'testing123', password: 'Password123!' } }
      end

      before { post '/api/v1/auth/register', params: register_params }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'creates user successfully' do
        new_user = User.find_by(username: register_params[:credentials][:username])

        expect(new_user.authenticate(register_params[:credentials][:password])).to be_truthy
      end
    end
    context 'with bad params' do
      let(:register_params) do
        { credentials: { username: 'tes', password: 'password123!' } }
      end

      before { post '/api/v1/auth/register', params: register_params }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns valid errors' do
        expect(json['message']).to eq("validation_failed")
        expect(json['errors'].keys.size).to eq(2)
      end
    end
    
  end
end
