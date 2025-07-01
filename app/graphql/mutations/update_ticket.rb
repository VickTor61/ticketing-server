# frozen_string_literal: true

module Mutations
  class UpdateTicket < BaseMutation
    field :ticket, Types::TicketType, null: false

    argument :id, Integer, required: true
    argument :priority, Types::TicketPriorityType, required: false
    argument :status, Types::TicketStatusType, required: false

    def resolve(id:, priority: nil, status: nil)
      user = context[:current_user]

      raise GraphQL::ExecutionError, "Only agents can edit tickets" unless user&.agent?

      ticket = ::Ticket.find(id)

      update_attributes = {}
      update_attributes[:priority] = priority if priority.present?
      update_attributes[:status] = status if status.present?

      if update_attributes.empty?
        raise GraphQL::ExecutionError, "At least one field (priority or status) must be provided"
      end

      ticket.update!(update_attributes)
      ticket.close! if status == "closed"

      { ticket: ticket }

    rescue StandardError => e
      raise GraphQL::ExecutionError, e.message
    end
  end
end
