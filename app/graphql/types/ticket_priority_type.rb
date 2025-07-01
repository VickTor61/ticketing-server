# frozen_string_literal: true

module Types
  class TicketPriorityType < Types::BaseEnum
    description "Ticket priority enum"

    value "low", "Priority is low", value: "low"
    value "medium", "Priority is medium", value:"medium"
    value "high", "Priority is high", value: "high"
    value "urgent", "Priority is urgent", value:"urgent"
  end
end
