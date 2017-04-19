module Wallaby
  # Wallaby's application controller.
  # Default to inherit from ::ApplicationController
  # It is responsible for handling exceptions
  class ApplicationController < configuration.base_controller
    helper Wallaby::ApplicationHelper

    rescue_from \
      Wallaby::ResourceNotFound,
      Wallaby::ModelNotFound,
      with: :not_found
    rescue_from ActionController::ParameterMissing, with: :unprocessable_entity

    layout 'wallaby/application'

    def not_found(exception = nil)
      @exception = exception
      render 'wallaby/errors/not_found', status: 404
    end

    def unprocessable_entity(exception)
      @exception = exception
      render 'wallaby/errors/unprocessable_entity', status: 422
    end
  end
end
