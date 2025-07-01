require "test_helper"

class Mutations::TicketTest < ActiveSupport::TestCase
  def setup
    agent = User.create!(
      email: "agent@example.com",
      first_name: "Test",
      last_name: "User",
      role: "agent",
      password: "password123",
      password_confirmation: "password123"
    )

    customer = User.create!(
      email: "customer@example.com",
      first_name: "Test",
      last_name: "User",
      role: "customer",
      password: "password123",
      password_confirmation: "password123"
    )

    @agent = (login_agent agent)["user"]
    @customer = (login_customer customer)["user"]
  end

  test "shows error message when agent tries to create ticket" do
    query = <<~GQL
      mutation createTicket($input: TicketInput!) {
        createTicket(input: $input) {
          ticket {
            id
            title
            description
            closedAt
            createdAt
            status
            priority
            canComment
            customer {
              email
              firstName
              lastName
            }
            commentsCount
          }
        }
      }
    GQL

    variables = {
      input: {
        title: Faker::Book.title,
        description: Faker::Lorem.sentence(word_count: 2),
        priority: "low",
        userId: @agent["id"].to_i
      }
    }

    result = @schema.execute(query, variables: variables)
    assert result["errors"].present?
    error = result["errors"].first
    assert_equal "Only customers can create tickets", error["message"]
  end

  test "customer can create a new ticket" do
    query = <<~GQL
      mutation createTicket($input: TicketInput!) {
        createTicket(input: $input) {
          ticket {
            id
            title
            description
            closedAt
            createdAt
            status
            priority
            canComment
            customer {
              id
              email
              firstName
              lastName
            }
            commentsCount
          }
        }
      }
    GQL

    variables = {
      input: {
        title: Faker::Book.title,
        description: Faker::Lorem.sentence(word_count: 2),
        priority: "low",
        userId: @customer["id"].to_i
      }
    }

    result = @schema.execute(query, variables: variables)
    assert_nil result["errors"]
    created_ticket = result.to_h.dig("data", "createTicket")["ticket"]
    refute_nil created_ticket["id"]
    assert created_ticket["customer"]["id"], @customer["id"]
  end
end
