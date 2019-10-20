class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected

    def after_sign_in_path_for(resource)
      stored_location_for(resource) || accounts_path
    end

    def after_sign_out_path_for(resource_or_scope)
      new_user_session_path
    end
  
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    end

    def render_404
      raise ActionController::RoutingError.new('Not Found')
    end
end
