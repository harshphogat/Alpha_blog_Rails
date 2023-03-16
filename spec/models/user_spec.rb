require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = User.new(username: 'harsh', email: 'test@abc.com', password: 'Abcdef@1234')
    @user.save
  end

  context '::username validation' do
    it '::must have a username' do
      @user.username = ''
      expect(@user).to_not be_valid
    end

    it '::username should not be empty' do
      @user.username = '               '
      expect(@user).to_not be_valid
    end

    it '::username must be unique' do
      @user2 = User.new(username: 'harsh', email: 'test@ab.com', password: 'Abcdef@12345')
      expect(@user2).to_not be_valid
    end

    it '::username length should be more than 3' do
      @user.username = 'aa'
      expect(@user).to_not be_valid
    end

    it '::username length should be less than 25' do
      @user.username = 'a' * 26
      expect(@user).to_not be_valid
    end
  end

  context '::email model validation' do
    it '::must have email' do
      @user.email = ''
      expect(@user).to_not be_valid
    end

    it '::must have valid email' do
      @user.email = 'test.com@abc'
      expect(@user).to_not be_valid
    end

    it '::email must be unique' do
      @user2 = User.new(username: 'hars', email: 'test@abc.com', password: 'Abcdef@12345')
      @user2.save
      expect(@user2).to_not be_valid
    end

    it '::email should be less than 105' do
      @user.email = 'ab' * 50 + '@example.com'
      expect(@user).to_not be_valid
    end
  end

  context '::password validation' do
    it '::password length must be more than 7' do
      @user.password = 'Abcde@1'
      expect(@user).to_not be_valid
    end

    it '::password must be valid' do
      @user.password = 'password'
      expect(@user).to_not be_valid
    end
  end
end
