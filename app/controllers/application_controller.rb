class ApplicationController < ActionController::API
  def encode_token(payload)
    JWT.encode(payload, 'secret')
  end

  def decode_token
    auth_header = request.headers['Authorization']

    return unless auth_header

    token = auth_header.split(' ').last

    begin
      JWT.decode(token, 'secret', true, algorithm: 'HS256')
    rescue JWT::DecodeError
      nil
    end
  end

  def authorized_user
    decoded_token = decode_token

    return unless decode_token

    user_id = decoded_token[0]['user_id']
    @user = User.find_by(id: user_id)
  end

  def authorize
    render json: { message: 'Você precisa estar logado!' }, status: :unauthorized unless authorized_user
  end
end
