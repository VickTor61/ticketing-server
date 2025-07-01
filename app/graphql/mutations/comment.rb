# frozen_string_literal: true

module Mutations
  class Comment < BaseMutation
    field :comment, Types::CommentType, null: false

    argument :content, String, required: true
    argument :user_id, Integer, required: true
    argument :ticket_id, Integer, required: true

    def resolve(content:, user_id:, ticket_id:)
      comment = ::Comment.create!(content:, user_id:, ticket_id:)
      { comment: comment }

    rescue ActiveRecord::RecordInvalid => e
      raise GraphQL::ExecutionError, e.record.errors.full_messages.join(", ")
    rescue StandardError => e
      raise GraphQL::ExecutionError, e.message
    end
  end
end
