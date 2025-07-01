require "test_helper"

class Mutations::CreateUserTest < ActiveSupport::TestCase
  def setup
    @agent = users(:agent)
    @customer = users(:customer)
    @ticket = tickets(:one)

    @schema = TicketingSchema
  end

  test "show error message when a customer attempts to comment on a ticket an agent as not commented on" do
    query = <<~GQL
        mutation CreateComment($input: CommentInput!) {
        createComment(input: $input) {
          comment {
            id
          }
        }
      }
    GQL

    variables = {
      input: {
        ticketId: @ticket.id,
        userId: @customer.id,
        content: Faker::Lorem.sentence(word_count: 3)
      }
    }
    result = @schema.execute(query, variables: variables, context: { current_user: @customer })

    assert result["errors"].present?
    error = result["errors"].first
    assert_equal "User Cannot comment until an agent has commented on the ticket.", error["message"]
  end

  test "should create comment with valid params" do
    query = <<~GQL
        mutation CreateComment($input: CommentInput!) {
        createComment(input: $input) {
          comment {
            id
          }
        }
      }
    GQL

    variables = {
      input: {
        ticketId: @ticket.id,
        userId: @agent.id,
        content: Faker::Lorem.sentence(word_count: 3)
      }
    }
    result = @schema.execute(query, variables: variables, context: { current_user: @agent })
    assert_nil result["errors"]
    refute_nil result.to_h["data"]["createComment"]["comment"]
  end
end
