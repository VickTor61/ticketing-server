# frozen_string_literal: true

module Types
  class CsvExportType < Types::BaseObject
    field :content, String, null: false, description: "CSV file content as string"
    field :filename, String, null: false, description: "Suggested filename for download"
    field :content_type, String, null: false, description: "MIME type for the file"
  end
end
