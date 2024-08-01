class SessionsController < Devise::SessionsController
  include RackSessionsFix
  respond_to :json

  # Override the create method to handle JSON responses
  def create
    user = User.find_by(email: params[:user][:email])
    if user&.valid_for_authentication? { user.valid_password?(params[:user][:password]) }
      sign_in(resource_name, user)
      render json: { message: 'Logged in successfully.', user: user.as_json(only: [:id, :admin]) }, status: :ok
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
    # head :no_content
    if current_user
      render json: { message: 'Logged out successfully.' }, status: :ok
    else
      render json: { errors: ['User was not logged in.'] }, status: :unauthorized
    end
  end
end

