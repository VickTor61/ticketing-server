module JwtAuthentication
  extend ActiveSupport::Concern

  def authenticate_user!
    token = extract_token_from_headers
    return nil unless token

    secret = Rails.application.credentials.devise_jwt_secret_key
    begin
      decoded_token = JWT.decode(token, secret, true, { algorithm: "HS256" })[0]
      @current_user = User.find_by(jti: decoded_token["jti"])

    rescue JWT::ExpiredSignature
      @token_expired = true
      nil
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      nil
    end
  end

  def current_user
    @current_user
  end

  def token_expired?
    @token_expired || false
  end

  def revoke_jwt_token!
    return unless current_user
    current_user.update!(jti: SecureRandom.uuid)
  end

  private

  def extract_token_from_headers
    auth_header = request.headers["Authorization"]
    return nil unless auth_header

    auth_header.split(" ").last if auth_header.start_with?("Bearer ")
  end
end
