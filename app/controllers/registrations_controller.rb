class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

    def respond_with(resource, opt = {})
      register_success && return if resource.persisted?
      p resource.errors.full_messages
      register_failed
    end

    def register_success
      render json: {
        message: 'Signed up successfull.',
        user: current_user
      }, status: :ok
    end

    def register_failed
      render json: { message: 'Something went wrong.' }, status: :unprocessable_entity
    end
end