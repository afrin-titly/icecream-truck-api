class SessionsController < Devise::SessionsController
  include RackSessionsFix
  respond_to :json

  # Override the create method to handle JSON responses
  def create
    user = User.find_by(email: params[:user][:email])
    if user&.valid_for_authentication? { user.valid_password?(params[:user][:password]) }
      sign_in(resource_name, user)
      # render json: { message: 'Logged in successfully.' }, status: :ok
      render json: { message: 'Logged in successfully.', user: user.as_json(only: [:id, :email, :admin]) }, status: :ok
    else
      render_invalid_login_attempt
    end
  end

  private

  def render_invalid_login_attempt
    render json: { errors: ['Invalid Email or password.'] }, status: :unauthorized
  end

  def respond_with(resource, _opts = {})
    render json: { message: 'Logged in successfully.' }, status: :ok
  end

  def respond_to_on_destroy
    head :no_content
  end
end

