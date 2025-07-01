# frozen_string_literal: true

module Mutations
  class LoginUser < BaseMutation
    description "Login user"

    field :user, Types::UserType, null: false
    field :token, String, null: false

    argument :email, String, required: true
    argument :password, String, required: true

    def resolve(email:, password:)
      user = User.find_for_database_authentication(email: email)
      unless user&.valid_password?(password)
        raise GraphQL::ExecutionError, "Invalid email or password"
      end

      token = user.generate_token

      { user: user, token: token }

    rescue StandardError => e
      raise GraphQL::ExecutionError, e.message
    end
  end
end
