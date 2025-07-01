# frozen_string_literal: true

module Types
  class RegistrationType < Types::BaseInputObject
    argument :first_name, String, required: true
    argument :last_name, String, required: true
    argument :email, String, required: true
    argument :role, Types::RoleType, required: true
    argument :password, String, required: true
    argument :password_confirmation, String, required: true
  end
end
