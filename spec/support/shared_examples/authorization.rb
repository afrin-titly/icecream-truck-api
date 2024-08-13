RSpec.shared_examples "admin authorization" do
  context "when user is not admin" do
    before do
      request.headers.merge!(user_headers)
    end

    it "denies access to non-admin user" do
      subject
      expect(response).to have_http_status(:unauthorized)
    end
  end
end