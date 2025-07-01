module Resolvers
  class ExportClosedTickets < BaseResolver
    require "base64"
    description "Export closed tickets from last month"

    type Types::CsvExportType, null: false

    def resolve
      user = context[:current_user]

      raise GraphQL::ExecutionError, "only agents can export tickets" unless user&.agent?

      csv_content = ExportClosedTicketsService.call
      encoded_data = Base64.strict_encode64(csv_content)

      {
        content: encoded_data,
        filename: "closed_tickets_#{Date.current.strftime('%Y_%m')}.csv",
        content_type: "text/csv"
      }

    rescue StandardError => e
      GraphQL::ExecutionError.new("Failed to export tickets: #{e.message}")
    end
  end
end
