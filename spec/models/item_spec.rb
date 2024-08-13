require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:category) { create(:category) }
  let(:flavor) { create(:flavor) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      item = Item.new(name: 'Test Item', price: 10.00, category: category, flavor: flavor, stock: 100)
      expect(item).to be_valid
    end

    it 'is invalid without a name' do
      item = Item.new(name: nil, price: 10.00, category: category, stock: 100)
      expect(item).not_to be_valid
      expect(item.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without a price' do
      item = Item.new(name: 'Test Item', price: nil, category: category, stock: 100)
      expect(item).not_to be_valid
      expect(item.errors[:price]).to include("can't be blank")
    end

    it 'is invalid without a category' do
      item = Item.new(name: 'Test Item', price: 10.00, category: nil, stock: 100)
      expect(item).not_to be_valid
      expect(item.errors[:category]).to include("must exist")
    end

    it 'is invalid without stock' do
      item = Item.new(name: 'Test Item', price: 10.00, category: category, stock: nil)
      expect(item).not_to be_valid
      expect(item.errors[:stock]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it { should belong_to(:category) }
    it { should belong_to(:flavor).optional }
    it { should have_many(:sales) }
  end

  describe '#as_json' do
    it 'includes the flavor and excludes the flavor_id' do
      item = create(:item, name: 'Test Item', category: category, flavor: flavor, stock: 100)
      expect(item.as_json).to include('flavor')
      expect(item.as_json).not_to include('flavor_id')
    end
  end
end
