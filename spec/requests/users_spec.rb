require 'rails_helper'
require 'signin_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET new' do
    before(:each) do
      get signup_path
    end
    it '::returns a successful response and render template' do
      expect(response).to be_successful
      expect(response).to render_template(:new)
      expect(response.body).to include('Sign Up')
    end

    it '::assign new user to @user' do
      expect(assigns(:user)).to be_a_new(User)
      expect do
        post '/users',
             params: {
               user: {
                 username: 'valid',
                 email: 'valid@gmail.com',
                 password: 'Abcdef@123'
               }
             }
      end.to change(User, :count).by(1)
      expect(response).to redirect_to(articles_path)
      follow_redirect!
      expect(response.body).to include('signed up')
    end

    it '::must be a valid user' do
      expect do
        post '/users',
             params: {
               user: {
                 username: 'invalid',
                 email: 'invalid@example.com',
                 password: 'test@1'
               }
             }
      end.to change(User, :count).by(0)
    end
  end

  describe 'GET edit' do
    before(:each) do
      @user1 = User.create(username: 'tester', email: 'test@abc.com', password: 'Abcde@123')
    end

    it '::get user edit page' do
      user = sign_in
      get edit_user_path(user)
      expect(response).to be_successful
      expect(response.body).to include('Update')
    end

    it '::get user edit page --without login' do
      get edit_user_path(@user1)
      expect(response).to_not be_successful
    end

    it '::get user edit page --admin' do
      sign_in(true)
      get edit_user_path(@user1)
      expect(response).to_not be_successful
    end

    it '::get user edit page --non admin and non current user' do
      sign_in
      get edit_user_path(@user1)
      expect(response).to redirect_to(@user1)
      follow_redirect!
      expect(response.body).to include('your profile')
    end

    it '::update user profile' do
      user = sign_in
      patch "/users/#{user.id}", params: {
        user: {
          username: 'updated',
          password: 'Abcdef@123'
        }
      }
      expect(response).to redirect_to(user_path(user))
      follow_redirect!
      expect(response.body).to include('updated')
    end

    it '::update user profile --admin' do
      sign_in(true)
      patch "/users/#{@user1.id}", params: {
        user: {
          username: 'updated'
        }
      }
      expect(response).to_not be_successful
    end

    it '::update user profile --not admin and not current user' do
      sign_in
      patch "/users/#{@user1.id}", params: {
        user: {
          username: 'updated'
        }
      }
      expect(response).to_not be_successful
    end

    it '::update user profile --not logged_in' do
      patch "/users/#{@user1.id}", params: {
        user: {
          username: 'updated'
        }
      }
      expect(response).to_not be_successful
    end
  end

  describe 'Listing user' do
    before(:each) do
      @user1 = User.create(username: 'tester', email: 'test@abc.com', password: 'Abcde@123')
    end

    it '::get user list' do
      get users_path
      expect(response).to be_successful
      expect(response.body).to include('tester')
    end

    it '::get user list --logged in' do
      sign_in
      get users_path
      expect(response).to be_successful
      expect(response.body).to include('Edit')
    end

    it '::get user list --admin' do
      sign_in(true)
      get users_path
      expect(response).to be_successful
      expect(response.body).to include('Delete')
    end
  end

  describe 'Show user' do
    before(:each) do
      @user1 = User.create(username: 'tester', email: 'test@abc.com', password: 'Abcde@123')
    end

    it '::get show user profile' do
      get user_path(@user1)
      expect(response).to be_successful
    end

    it '::get show user profile --logged in' do
      user = sign_in
      get user_path(user)
      expect(response).to be_successful
      expect(response.body).to include('Edit')
    end

    it '::get show user profile --admin' do
      sign_in(true)
      get user_path(@user1)
      expect(response).to be_successful
      expect(response.body).to include('Delete')
    end
  end

  describe 'Delete User' do
    before(:each) do
      @user1 = User.create(username: 'tester', email: 'test@abc.com', password: 'Abcde@123')
    end

    it '::delete user --signed in' do
      user = sign_in
      expect do
        delete "/users/#{user.id}"
      end.to change(User, :count).by(-1)
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include('deleted')
    end

    it '::delete user --admin' do
      sign_in(true)
      expect do
        delete "/users/#{@user1.id}"
      end.to change(User, :count).by(-1)
      expect(response).to redirect_to(root_path)
      follow_redirect!
    end

    it '::delete user --not admin and not current user' do
      sign_in
      expect do
        delete "/users/#{@user1.id}"
      end.to change(User, :count).by(0)
    end

    it '::delete user --not signed in' do
      expect do
        delete "/users/#{@user1.id}"
      end.to change(User, :count).by(0)
      expect(response).to_not be_successful
    end
  end
end
