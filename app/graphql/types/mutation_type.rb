# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :update_ticket, mutation: Mutations::UpdateTicket
    field :create_comment, mutation: Mutations::Comment
    field :create_ticket, mutation: Mutations::Ticket
    field :create_user, mutation: Mutations::CreateUser
    field :login, mutation: Mutations::LoginUser
    field :closed_tickets, resolver: Resolvers::ExportClosedTickets
    field :logout, Boolean, null: false, description: "Sign out current user"

    def logout
      return false unless context[:current_user]

      context[:controller].revoke_jwt_token!
      true
    end
  end
end
