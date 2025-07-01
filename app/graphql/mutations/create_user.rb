# frozen_string_literal: true

module Mutations
  class CreateUser < BaseMutation
    description "Creates a new user"

    argument :user_input, Types::RegistrationType, required: true

    field :user, Types::UserType, null: false


    def resolve(user_input:)
      user = ::User.new(**user_input)

      raise GraphQL::ExecutionError.new "Error creating account.", extensions: user.errors.to_hash unless user.save

      { user: user }

    rescue StandardError => e
      raise GraphQL::ExecutionError, e.message
    end
  end
end
