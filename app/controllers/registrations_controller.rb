# class RegistrationsController < Devise::RegistrationsController
#   include RackSessionsFix
#   respond_to :json

#   private

#   def respond_with(resource, _opts = {})
#     if resource.persisted?
#       render json: { message: 'Signed up successfully.' }, status: :ok
#     else
#       render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
#     end
#   end

#   def respond_to_on_destroy
#     head :no_content
#   end
# end

class RegistrationsController < Devise::RegistrationsController
  include RackSessionsFix
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      sign_in(resource_name, resource) # This will trigger Devise to generate the JWT token
      render json: { message: 'Signed up successfully.' }, status: :ok
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def respond_to_on_destroy
    head :no_content
  end
end
