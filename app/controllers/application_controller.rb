class ApplicationController < ActionController::API
    include JWTSession::RailsAuthorization
    rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized

    private

    def current_user 
        @current_user ||= User.find(payload['user_id'])
    end

    def not_authorized
        render json: { error: 'Not Authorized'}, status: :unauthorized
    end
end
