require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe FlavorsController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }
  let!(:flavor) { create(:flavor) }

  let(:auth_headers) { Devise::JWT::TestHelpers.auth_headers({}, admin) }
  let(:user_headers) { Devise::JWT::TestHelpers.auth_headers({}, user) }

  before do
    request.headers.merge!(auth_headers)
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to be_an_instance_of(Array)
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: flavor.to_param }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["id"]).to eq(flavor.id)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_attributes) { { name: 'Vanilla' } }

      it "creates a new Flavor" do
        expect {
          post :create, params: { flavor: valid_attributes }
        }.to change(Flavor, :count).by(1)
      end

      it "returns a created status" do
        post :create, params: { flavor: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["message"]).to eq("Flavor created successfully!")
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { { name: '' } }

      it "does not create a new Flavor" do
        expect {
          post :create, params: { flavor: invalid_attributes }
        }.not_to change(Flavor, :count)
      end

      it "returns an unprocessable entity status" do
        post :create, params: { flavor: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH/PUT #update" do
    context "with valid parameters" do
      let(:new_attributes) { { name: 'Chocolate' } }

      it "updates the requested flavor" do
        put :update, params: { id: flavor.to_param, flavor: new_attributes }
        flavor.reload
        expect(flavor.name).to eq('Chocolate')
      end

      it "returns a success response" do
        put :update, params: { id: flavor.to_param, flavor: new_attributes }
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { { name: '' } }

      it "does not update the requested flavor" do
        put :update, params: { id: flavor.to_param, flavor: invalid_attributes }
        flavor.reload
        expect(flavor.name).not_to eq('')
      end

      it "returns an unprocessable entity status" do
        put :update, params: { id: flavor.to_param, flavor: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested flavor" do
      expect {
        delete :destroy, params: { id: flavor.to_param }
      }.to change(Flavor, :count).by(-1)
    end

    it "returns a no content status" do
      delete :destroy, params: { id: flavor.to_param }
      expect(response).to have_http_status(:no_content)
    end
  end

  describe "Authorization" do
    it_behaves_like "admin authorization" do
      subject { get :index }
    end
  end
end
