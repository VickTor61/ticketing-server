# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.
    field :me, Types::UserType, null: true, description: "Get current user"

    def me
      context[:current_user]
    end

    field :tickets, [Types::TicketType], null: true, description: "Fetches all tickets"
    field :comments, [Types::CommentType], null: true, description: "Fetch comments for a ticket" do
      argument :ticket_id, ID, required: true
    end


    def tickets
      user = context[:current_user]
      return [] unless user

      role = user.role
      tickets = Ticket.includes(:comments, :customer)

      if role == "customer"
        tickets = tickets.where(customer_id: user.id)
      elsif role == "agent"
        tickets = tickets.all
      else
        return []
      end
      tickets.order(created_at: :desc)
    end

    def comments(ticket_id:)
      user = context[:current_user]
      return [] unless user

      ::Comment.where(ticket_id: ticket_id).order(created_at: :desc)
    end
  end
end
