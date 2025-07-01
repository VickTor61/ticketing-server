# frozen_string_literal: true

module Mutations
  class Ticket < BaseMutation
    field :ticket, Types::TicketType, null: false

    argument :title, String, required: true
    argument :description, String, required: true
    argument :priority, Types::TicketPriorityType, required: false
    argument :user_id, Integer, required: true

    def resolve(title:, description:, user_id:, priority:)
      user = ::User.find(user_id)

      raise GraphQL::ExecutionError, "Only customers can create tickets" unless user&.customer?

      ticket = ::Ticket.create!(title:, description:, customer_id: user_id, priority:)

      { ticket: ticket }

    rescue ActiveRecord::RecordInvalid => e
      raise GraphQL::ExecutionError, "Invalid ticket params"
    rescue StandardError => e
      raise GraphQL::ExecutionError, "#{e.message}"
    end
  end
end
