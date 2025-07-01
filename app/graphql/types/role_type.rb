# frozen_string_literal: true

module Types
  class RoleType < Types::BaseEnum
    description "Role enum"

    value "customer", "A customer user", value: "customer"
    value "agent", "An agent user", value: "agent"
  end
end
