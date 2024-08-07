class ApplicationController < ActionController::API
    before_action :configure_permitted_parameters, if: :devise_controller?

    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def is_admin
      unless current_user.admin?
        render json: {error: "Access Denied"}, status: :unauthorized
      end
    end

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    end

    def record_not_found
      render json: { error: 'Record not found' }, status: :not_found
    end

    def authenticate_user!
      unless user_signed_in?
        render json: { error: 'You need to sign in or sign up before continuing.' }, status: :unauthorized
      end
    end
  end
