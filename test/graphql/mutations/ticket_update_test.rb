require "test_helper"

class Mutations::TicketUpdateTest < ActiveSupport::TestCase
  def setup
    @ticket = tickets(:one)
    agent = User.create!(
      email: "agent@example.com",
      first_name: "Test",
      last_name: "User",
      role: "agent",
      password: "password123",
      password_confirmation: "password123"
    )
    @agent = agent
    @schema = TicketingSchema
  end

  test "agents can update a ticket status and priority field" do
    query = <<~GQL
      mutation UpdateTicket($input: UpdateTicketInput!) {
             updateTicket(input: $input) {
                ticket {
                  id
                  status
                  priority
                }
              }
            }
    GQL

    variables = {
      input: {
        id: @ticket.id,
        priority: "high",
        status: "in_progress"
      }
    }

    result = @schema.execute(query, variables: variables, context: { current_user: @agent })
    assert_nil result["errors"]
    updated_ticket = result.to_h.dig("data", "updateTicket")["ticket"]
    refute_nil updated_ticket["id"]
    assert updated_ticket["priority"], "high"
    assert updated_ticket["status"], "in_progress"
  end

  test "cannot update ticket if user is not an agent" do
    query = <<~GQL
      mutation UpdateTicket($input: UpdateTicketInput!) {
             updateTicket(input: $input) {
                ticket {
                  id
                  status
                  priority
                }
              }
            }
    GQL

    variables = {
      input: {
        id: @ticket.id,
        priority: "high",
        status: "in_progress"
      }
    }
    result = @schema.execute(query, variables: variables, context: { current_user: nil })
    assert result["errors"].present?
    error = result["errors"].first
    assert_equal "Only agents can edit tickets", error["message"]
  end

  test "shows error for invalid params" do
    query = <<~GQL
      mutation UpdateTicket($input: UpdateTicketInput!) {
             updateTicket(input: $input) {
                ticket {
                  id
                  status
                  priority
                }
              }
            }
    GQL

    variables = {
      input: {
        id: @ticket.id
      }
    }
    result = @schema.execute(query, variables: variables, context: { current_user: @agent })
    assert result["errors"].present?
    error = result["errors"].first
    assert_equal "At least one field (priority or status) must be provided", error["message"]
  end

  test "close ticket if status param is 'closed'" do
    query = <<~GQL
      mutation UpdateTicket($input: UpdateTicketInput!) {
             updateTicket(input: $input) {
                ticket {
                  id
                  status
                  priority
                  closedAt
                }
              }
            }
    GQL

    variables = {
      input: {
        id: @ticket.id,
        status: "closed"
      }
    }
    result = @schema.execute(query, variables: variables, context: { current_user: @agent })
    assert_nil result["errors"]
    updated_ticket = result.to_h.dig("data", "updateTicket")["ticket"]
    assert updated_ticket["status"], "closed"
    refute_nil updated_ticket["closedAt"]
  end
end
