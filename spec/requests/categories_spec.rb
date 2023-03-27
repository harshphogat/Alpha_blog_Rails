require 'rails_helper'
require 'signin_helper'

RSpec.describe 'Categories', type: :request do
  describe 'New category' do
    it '::get new category --admin' do
      sign_in(true)
      get new_category_path
      expect(response).to be_successful
    end

    it '::get new category --non admin' do
      sign_in
      get new_category_path
      expect(response).to_not be_successful
    end

    it '::get new category --no sign in' do
      get new_category_path
      expect(response).to_not be_successful
    end

    it '::post create category --admin' do
      sign_in(true)
      expect do
        post '/categories', params: {
          category: {
            name: 'health'
          }
        }
      end.to change(Category, :count).by(1)
      follow_redirect!
      expect(response.body).to include('created')
    end

    it '::post create category --non admin' do
      sign_in
      expect do
        post '/categories', params: {
          category: {
            name: 'health'
          }
        }
      end.to change(Category, :count).by(0)
      expect(response).to_not be_successful
    end

    it '::post create category --no sign in' do
      expect do
        post '/categories', params: {
          category: {
            name: 'health'
          }
        }
      end.to change(Category, :count).by(0)
      expect(response).to_not be_successful
    end

    it '::post create category --invalid details' do
      sign_in(true)
      expect do
        post '/categories', params: {
          category: {
            name: ''
          }
        }
      end.to change(Category, :count).by(0)
    end
  end

  describe 'Edit category' do
    before(:each) do
      @category = Category.create(name: 'tester')
    end

    it '::get edit category --admin' do
      sign_in(true)
      get edit_category_path(@category)
      expect(response).to be_successful
    end

    it '::get edit category --non admin' do
      sign_in
      get edit_category_path(@category)
      expect(response).to_not be_successful
    end

    it '::get edit category --no sign in' do
      get edit_category_path(@category)
      expect(response).to_not be_successful
    end

    it '::post edit category --admin' do
      sign_in(true)
      patch "/categories/#{@category.id}", params: {
        category: {
          name: 'updated'
        }
      }
      expect(response).to redirect_to(@category)
      follow_redirect!
      expect(response).to be_successful
    end

    it '::post edit category --non admin' do
      sign_in
      patch "/categories/#{@category.id}", params: {
        category: {
          name: 'updated'
        }
      }
      expect(response).to_not be_successful
    end

    it '::post edit category --no sign in' do
      patch "/categories/#{@category.id}", params: {
        category: {
          name: 'updated'
        }
      }
      expect(response).to_not be_successful
    end
  end

  describe 'Category list' do
    it '::get category list --admin' do
      sign_in(true)
      get categories_path
      expect(response).to be_successful
    end

    it '::get category list --non admin' do
      sign_in
      get categories_path
      expect(response).to be_successful
    end

    it '::get category list --no sign in' do
      get categories_path
      expect(response).to be_successful
    end
  end

  describe 'Show category' do
    before(:each) do
      @category = Category.create(name: 'tester')
    end

    it '::show category page --admin' do
      sign_in(true)
      get category_path(@category)
      expect(response).to be_successful
    end

    it '::show category page --non admin' do
      sign_in
      get category_path(@category)
      expect(response).to be_successful
    end

    it '::show category page --no sign in' do
      get category_path(@category)
      expect(response).to be_successful
    end
  end

  describe 'Destroy category' do
    before(:each) do
      @category = Category.create(name: 'tester')
    end

    it '::destroy category --admin' do
      sign_in(true)
      expect do
        delete "/categories/#{@category.id}"
      end.to change(Category, :count).by(-1)

      expect(response).to redirect_to(categories_path)
      follow_redirect!
      expect(response).to be_successful
    end

    it '::destroy category --non admin' do
      sign_in
      expect do
        delete "/categories/#{@category.id}"
      end.to change(Category, :count).by(0)

      expect(response).to_not be_successful
    end

    it '::destroy category --no sign in' do
      expect do
        delete "/categories/#{@category.id}"
      end.to change(Category, :count).by(0)

      expect(response).to_not be_successful
    end
  end
end
