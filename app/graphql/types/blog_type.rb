# frozen_string_literal: true

module Types
  class BlogType < Types::BaseObject
    field :id, ID, null: false
    field :title, String
    field :description, String
    field :user_name, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false

    def user_name
      user = object.user
      "#{user&.first_name} #{user&.last_name}".strip
    end
  end

  class BlogInputType < Types::BaseInputObject
    description "Attributes for creating or updating a blog"

    argument :title, String, required: true
    argument :description, String, required: false
    argument :user_id, ID, required: true
  end
end
