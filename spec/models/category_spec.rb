require 'rails_helper'

RSpec.describe Category, type: :model do
  # Associations
  it { should have_many(:items) }

  # Validations
  it { should validate_presence_of(:name) }

  # Valid Factory
  describe 'Factory' do
    it 'has a valid factory' do
      expect(build(:category)).to be_valid
    end
  end

  # Validations for presence
  describe 'validations' do
    it 'is valid with a name' do
      category = Category.new(name: 'Desserts')
      expect(category).to be_valid
    end

    it 'is invalid without a name' do
      category = Category.new(name: '')
      expect(category).to_not be_valid
    end
  end

  # Check for correct behavior of associations
  describe 'associations' do
    it 'can have many items' do
      category = Category.create(name: 'Snacks')
      item1 = category.items.create(name: 'Chips', price: 10.5, stock: 12)
      item2 = category.items.create(name: 'Cookies', price: 5.6, stock: 10)
      expect(category.items).to include(item1, item2)
    end
  end
end
