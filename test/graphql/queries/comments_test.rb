require "test_helper"

module Queries
  class CommentsTest < ActiveSupport::TestCase
    def setup
      @schema = TicketingSchema
      @customer = users(:customer)
      @agent = users(:agent)
      @ticket1 = tickets(:one)
      @comment1 = comments(:first)
      @comment2 = comments(:second)
    end

    test "should return comments for a given ticket" do
      query = <<~GQL
        query($ticketId: ID!) {
          comments(ticketId: $ticketId) {
            id
            content
          }
        }
      GQL

      result = @schema.execute(query, variables: { ticketId: @ticket1.id }, context: { current_user: @customer })
      assert_nil result["errors"]
      comments_data = result.dig("data", "comments")
      assert_equal 2, comments_data.count
      assert_equal @comment1.id.to_s, comments_data[0]["id"]
      assert_equal @comment2.id.to_s, comments_data[1]["id"]
    end

    test "should return empty array if no user logged in" do
      query = <<~GQL
        query($ticketId: ID!) {
          comments(ticketId: $ticketId) {
            id
          }
        }
      GQL

      result = @schema.execute(query, variables: { ticketId: @ticket1.id }, context: { current_user: nil })
      assert_nil result["errors"]
      assert_empty result.dig("data", "comments")
    end
  end
end