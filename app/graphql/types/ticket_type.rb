# frozen_string_literal: true

module Types
  class TicketType < Types::BaseObject
    field :id, ID, null: false
    field :closed_at, GraphQL::Types::ISO8601DateTime
    field :title, String
    field :description, String
    field :priority, TicketPriorityType
    field :status, TicketStatusType
    field :customer, Types::UserType, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :comments_count, Integer, null: false
    field :creator, Types::UserType
    field :can_comment, Boolean, null: false

    def can_comment
      object.customer_can_comment?
    end

    def comments_count
      object.comments.count
    end
  end
end
