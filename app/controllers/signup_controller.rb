class SignupController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save 
      payload = { user_id: user.id}
      session = JWTSession::Session.new(payload, refresh_by_access_allowed: true)
      tokens = session.login 

      response.set_cookie(JWTSession.access_cookie, 
                            value: tokens[:access],
                            httponly: true,
                            secure: Rails.env.production?
                          )
      render json: { csrf: tokens[:csrf] }

    else
      render json: { error: user.error.full_messages.join(' ') }, status: :unprocessable_entity
    end

  end

  private
  def user_params
    params.permit(:email, :password, :password_confirmation)
  end

end
