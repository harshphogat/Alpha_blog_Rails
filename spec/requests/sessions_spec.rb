require 'rails_helper'
require 'signin_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'New Session' do
    it '::get new session' do
      get login_path
      expect(response).to be_successful
      expect(response.body).to include('Login')
    end

    it '::post new session' do
      user = User.create(username: 'testing', email: 'test@abc.com', password: 'Abcdef@123')
      post '/login', params: {
        session: {
          email: 'test@abc.com',
          password: 'Abcdef@123'
        }
      }
      expect(response).to redirect_to(user)
      follow_redirect!
      expect(response.body).to include('Logout')
      expect(response).to be_successful
    end

    it '::post new session --invalid user' do
      post '/login', params: {
        session: {
          email: 'test@abc.com',
          password: 'Abcdef@123'
        }
      }
      expect(response.body).to include('Incorrect')
    end

    it '::post new session --invalid details' do
      User.create(username: 'testing', email: 'test@abc.com', password: 'Abcdef@123')
      post '/login', params: {
        session: {
          email: 'test@abc.com',
          password: 'Abcdef@1'
        }
      }
      expect(response.body).to include('Incorrect')
    end
  end

  describe 'Destroy Session' do
    it '::logout' do
      sign_in
      delete '/logout'
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include('Login')
    end
  end
end
