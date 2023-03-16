require 'rails_helper'

RSpec.describe Category, type: :model do
  context '::category validation' do
    before(:each) do
      @category = Category.new(name: 'testing')
      @category.save
    end

    it '::must have a name' do
      @category.name = ''
      expect(@category).to_not be_valid
    end

    it '::name length should be more than 4' do
      @category.name = 'a' * 4
      expect(@category).to_not be_valid
    end

    it '::name length should be less than 26' do
      @category.name = 'ab' * 13
      expect(@category).to_not be_valid
    end
  end
end
