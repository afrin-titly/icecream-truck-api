require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe SalesController, type: :controller do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:flavor) { create(:flavor) }

  # Associate the item with the flavor
  let(:item) { create(:item, stock: 10, price: 5, flavor: flavor) }
  let(:order) { create(:order, user: user) }

  let(:valid_sales_params) do
    {
      sales: [
        { item_id: item.id, flavor_id: flavor.id, quantity: 2 }
      ],
      user: { user_id: user.id }
    }
  end

  let(:auth_headers) { Devise::JWT::TestHelpers.auth_headers({}, admin) }
  let(:user_headers) { Devise::JWT::TestHelpers.auth_headers({}, user) }

  before do
    request.headers.merge!(auth_headers)
  end

  describe 'POST #purchase' do
    context 'with valid parameters' do
      it 'creates a new order and sales record' do
        expect do
          post :purchase, params: valid_sales_params
        end.to change(Order, :count).by(1).and change(Sale, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['message']).to eq('ENJOY!')
      end

      it 'reduces the item stock' do
        expect do
          post :purchase, params: valid_sales_params
          item.reload
        end.to change { item.stock }.by(-2)
      end
    end

    context 'with insufficient stock' do
      it 'does not create a sale record' do
        item.update(stock: 1)

        expect do
          post :purchase, params: valid_sales_params
        end.not_to change(Sale, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq("Insufficient stock for item id: #{item.id} name: #{item.name}")
      end
    end

    context 'when item not found' do
      let(:invalid_sales_params) do
        {
          sales: [
            { item_id: -1, flavor_id: flavor.id, quantity: 2 }
          ],
          user: { user_id: user.id }
        }
      end

      it 'returns a not found error' do
        post :purchase, params: invalid_sales_params
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to include('Record not found')
      end
    end
  end

  describe 'GET #total_sales' do
    let!(:sale) { create(:sale, order: order, item: item, quantity: 2, total_price: item.price * 2) }

    it 'returns the total sales for the given month' do
      get :total_sales, params: { month: Date.current.strftime('%Y-%m') }
      expect(response).to have_http_status(:ok)

      result = JSON.parse(response.body)['orders']
      expect(result).not_to be_empty
      expect(result.last['order_number']).to eq(order.order_number)
      expect(result.last['total_amount']).to eq(sale.total_price.to_s)
    end

    it 'returns an error for invalid month format' do
      get :total_sales, params: { month: 'invalid-month' }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to include('Invalid month format')
    end
  end
end
