require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe ItemsController, type: :controller do
  let(:category) { create(:category) }
  let(:flavor) { create(:flavor) }
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:regular_user) { create(:user) }
  let(:valid_attributes) { { name: 'Test Item', price: 10.00, category_id: category.id, flavor_id: flavor.id, stock: 100 } }
  let(:invalid_attributes) { { name: '', price: 10.00, category_id: category.id, stock: 100 } }
  let(:item) { create(:item, valid_attributes) }

  let(:auth_headers) { Devise::JWT::TestHelpers.auth_headers({}, admin) }
  let(:user_headers) { Devise::JWT::TestHelpers.auth_headers({}, user) }

  before do
    request.headers.merge!(auth_headers)
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
      expect(JSON.parse(response.body)).not_to be_empty
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: item.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'as an admin' do
      before { sign_in admin }

      context 'with valid params' do
        it 'creates a new Item' do
          expect {
            post :create, params: { item: valid_attributes }
          }.to change(Item, :count).by(1)
        end

        it 'renders a JSON response with the new item' do
          post :create, params: { item: valid_attributes }
          expect(response).to have_http_status(:created)
          expect(JSON.parse(response.body)).to include('name' => 'Test Item')
        end
      end

      context 'with invalid params' do
        it 'renders a JSON response with errors for the new item' do
          post :create, params: { item: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to have_key('name')
        end
      end
    end

    context 'as a regular user' do
      before { sign_in regular_user }

      it 'returns a unauthorized response' do
        post :create, params: { item: valid_attributes }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH/PUT #update' do
    context 'as an admin' do
      before { sign_in admin }

      context 'with valid params' do
        let(:new_attributes) { { name: 'Updated Item' } }

        it 'updates the requested item' do
          put :update, params: { id: item.to_param, item: new_attributes }
          item.reload
          expect(item.name).to eq('Updated Item')
        end

        it 'renders a JSON response with the item' do
          put :update, params: { id: item.to_param, item: new_attributes }
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)).to include('name' => 'Updated Item')
        end
      end

      context 'with invalid params' do
        it 'renders a JSON response with errors for the item' do
          put :update, params: { id: item.to_param, item: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to have_key('name')
        end
      end
    end

    context "Authorization" do
      it_behaves_like "admin authorization" do
        subject { put :update, params: { id: item.to_param, item: valid_attributes } }
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as an admin' do
      before { sign_in admin }

      it 'destroys the requested item' do
        item
        expect {
          delete :destroy, params: { id: item.to_param }
        }.to change(Item, :count).by(-1)
      end

      it 'renders a no content response' do
        delete :destroy, params: { id: item.to_param }
        expect(response).to have_http_status(:no_content)
      end
    end

    context "Authorization" do
      it_behaves_like "admin authorization" do
        subject { delete :destroy, params: { id: item.to_param } }
      end
    end
  end
end
