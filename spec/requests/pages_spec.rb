require 'rails_helper'
require 'signin_helper'

RSpec.describe 'Pages', type: :request do
  describe 'Home' do
    it '::home page --signed out' do
      get root_path
      expect(response).to be_successful
      expect(response.body).to include('Sign Up')
    end

    it '::home page --signed in' do
      sign_in
      get root_path
      follow_redirect!
      expect(response.body).to include('Articles')
    end
  end
end
