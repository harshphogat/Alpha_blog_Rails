require 'rails_helper'

RSpec.describe Article, type: :model do
  before(:each) do
    @article = Article.new(title: 'testing', description: 'the quick brown fox jumps over a little lazy dog.')
    @article.user = User.new(username: 'testuser', email: 'test@abc.com', password: 'Abcdef@1234')
    @article.save
  end

  context '::title validation' do
    it '::must have a title' do
      @article.title = ''
      expect(@article).to_not be_valid
    end

    it '::title must be unique' do
      @article2 = Article.new(title: 'testing', description: 'checking whether title is unique or not')
      @article2.user = User.new(username: 'testuser', email: 'test@abc.com', password: 'Abcdef@1234')
      expect(@article2).to_not be_valid
    end

    it '::title length must be more than 4' do
      @article.title = 'a' * 3
      expect(@article).to_not be_valid
    end

    it '::title length must be less than 16' do
      @article.title = 'a' * 16
      expect(@article).to_not be_valid
    end
  end

  context '::description validation' do
    it '::must have a description' do
      @article.description = ''
      expect(@article).to_not be_valid
    end

    it '::description length must be more than 24' do
      @article.description = 'a' * 24
      expect(@article).to_not be_valid
    end

    it '::description length must be less than 500' do
      @article.description = 'abcde ' * 100
      expect(@article).to_not be_valid
    end
  end
end
