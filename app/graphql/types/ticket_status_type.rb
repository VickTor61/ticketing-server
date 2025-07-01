# frozen_string_literal: true

module Types
  class TicketStatusType < Types::BaseEnum
    description "Ticket status enum"

    value "open", "Ticket is open", value: "open"
    value "in_progress", "Ticket is in progress", value: "in_progress"
    value "resolved", "Ticket has been resolved", value: "resolved"
    value "closed", "Ticket is closed", value: "closed"
  end
end
