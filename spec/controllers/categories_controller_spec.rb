require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe CategoriesController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }
  let!(:category) { create(:category) }
  let(:valid_attributes) { attributes_for(:category) }
  let(:invalid_attributes) { { name: '' } }

  let(:auth_headers) { Devise::JWT::TestHelpers.auth_headers({}, admin) }
  let(:user_headers) { Devise::JWT::TestHelpers.auth_headers({}, user) }

  before do
    request.headers.merge!(auth_headers)
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)
      expect(json_response.any? { |c| c['name'] == category.name }).to be(true)
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: category.to_param }
      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)
      expect(json_response['name']).to eq(category.name)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Category" do
        expect {
          post :create, params: { category: valid_attributes }
        }.to change(Category, :count).by(1)
      end

      it "renders a JSON response with the new category" do
        post :create, params: { category: valid_attributes }
        expect(response).to have_http_status(:created)

        json_response = JSON.parse(response.body)
        expect(json_response['category']['name']).to eq(valid_attributes[:name])
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new category" do
        post :create, params: { category: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)

        json_response = JSON.parse(response.body)
        expect(json_response['name']).to include("can't be blank")
      end
    end
  end

  describe "PATCH/PUT #update" do
    context "with valid params" do
      let(:new_attributes) { { name: "Updated Category" } }

      it "updates the requested category" do
        patch :update, params: { id: category.to_param, category: new_attributes }
        category.reload
        expect(category.name).to eq("Updated Category")
      end

      it "renders a JSON response with the updated category" do
        patch :update, params: { id: category.to_param, category: new_attributes }
        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq("Updated Category")
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the category" do
        patch :update, params: { id: category.to_param, category: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)

        json_response = JSON.parse(response.body)
        expect(json_response['name']).to include("can't be blank")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested category" do
      expect {
        delete :destroy, params: { id: category.to_param }
      }.to change(Category, :count).by(-1)
    end

    it "renders a no content response" do
      delete :destroy, params: { id: category.to_param }
      expect(response).to have_http_status(:no_content)
    end
  end

  describe "Authorization" do
    context "when user is not admin" do
      before do
        request.headers.merge!(user_headers)
      end

      it "denies access to non-admin user" do
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
