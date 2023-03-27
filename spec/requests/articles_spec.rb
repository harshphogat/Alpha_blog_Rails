require 'rails_helper'
require 'signin_helper'

RSpec.describe 'Articles', type: :request do
  describe 'New article' do
    it '::get new article --signed in' do
      sign_in
      get new_article_path
      expect(response).to be_successful
      expect(response.body).to include('Create')
    end

    it '::get new article --no sign in' do
      get new_article_path
      expect(response).to_not be_successful
    end

    it '::post create article' do
      sign_in
      expect do
        post '/articles', params: {
          article: {
            title: 'tester',
            description: 'used for testing purpose only'
          }
        }
      end.to change(Article, :count).by(1)
      follow_redirect!
      expect(response).to be_successful
    end

    it '::post create article --no sign in' do
      expect do
        post '/articles', params: {
          article: {
            title: 'tester',
            description: 'used for testing purpose only'
          }
        }
      end.to change(Article, :count).by(0)
      expect(response).to_not be_successful
    end

    it '::post create article --invalid details' do
      sign_in
      expect do
        post '/articles', params: {
          article: {
            title: '',
            description: 'used for testing purpose only'
          }
        }
      end.to change(Article, :count).by(0)
    end
  end

  describe 'Edit article' do
    before(:each) do
      @user = User.create(username: 'tester', email: 'testing@abc.com', password: 'Abcdef@123')
      @article = Article.create(title: 'test_article', description: 'testing purpose only and should not be used otherwise')
      @user.articles << @article
    end

    it '::get edit article' do
      article = new_article
      get edit_article_path(article)
      expect(response).to be_successful
      expect(response.body).to include('Update')
    end

    it '::get edit article --admin' do
      sign_in(true)
      get edit_article_path(@article)
      expect(response).to be_successful
    end

    it '::get edit article --non admin and non current user' do
      sign_in
      get edit_article_path(@article)
      expect(response).to_not be_successful
    end

    it '::get edit article --no sign in' do
      get edit_article_path(@article)
      expect(response).to_not be_successful
    end

    it '::post edit article' do
      article = new_article
      patch "/articles/#{article.id}", params: {
        article: {
          title: 'updated'
        }
      }
      expect(response).to redirect_to(article_path(article))
      follow_redirect!
      expect(response.body).to include('updated')
    end

    it '::post edit article --admin' do
      sign_in(true)
      patch "/articles/#{@article.id}", params: {
        article: {
          title: 'updated'
        }
      }
      expect(response).to redirect_to(article_path(@article))
      follow_redirect!
      expect(response.body).to include('updated')
    end

    it '::post edit article --non admin and non current user' do
      sign_in
      patch "/articles/#{@article.id}", params: {
        article: {
          title: 'updated'
        }
      }
      expect(response).to_not be_successful
    end
  end

  describe 'Article list' do
    it '::articles list' do
      get articles_path
      expect(response).to be_successful
      expect(response.body).to include('title')
    end

    it '::articles list --signed in' do
      sign_in
      get articles_path
      expect(response).to be_successful
      expect(response.body).to include('title')
    end
  end

  describe 'Show article' do
    before(:each) do
      @article = new_article
    end

    it '::show article' do
      get article_path(@article)
      expect(response).to be_successful
    end

    it '::show article --signed in' do
      sign_in
      get article_path(@article)
      expect(response).to be_successful
    end
  end

  describe 'Destroy article' do
    before(:each) do
      @user = User.create(username: 'tester', email: 'testing@abc.com', password: 'Abcdef@123')
      @article = Article.create(title: 'test_article', description: 'testing purpose only and should not be used otherwise')
      @user.articles << @article
    end

    it '::destroy article --no sign in' do
      expect do
        delete "/articles/#{@article.id}"
      end.to change(Article, :count).by(0)
      expect(response).to_not be_successful
    end

    it '::destroy article --non admin and non current user' do
      sign_in
      expect do
        delete "/articles/#{@article.id}"
      end.to change(Article, :count).by(0)
      expect(response).to_not be_successful
    end

    it '::destroy article --same user' do
      article = new_article
      expect do
        delete "/articles/#{article.id}"
      end.to change(Article, :count).by(-1)
      expect(response).to redirect_to(articles_path)
    end

    it '::destroy article --admin' do
      sign_in(true)
      expect do
        delete "/articles/#{@article.id}"
      end.to change(Article, :count).by(-1)
      expect(response).to redirect_to(articles_path)
    end
  end
end
