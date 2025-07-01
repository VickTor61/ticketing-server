require "test_helper"

module Queries
  class TicketsTest < ActiveSupport::TestCase
    def setup
      @schema = TicketingSchema
      @customer = users(:customer)
      @agent = users(:agent)
      @ticket1 = tickets(:one)
      @ticket2 = tickets(:two)
    end

    test "customer should only see their own tickets" do
      query = <<~GQL
        query {
          tickets {
            id
            title
            description
            status
            priority
          }
        }
      GQL

      result = @schema.execute(query, context: { current_user: @customer })
      assert_nil result["errors"]
      tickets_data = result.dig("data", "tickets")
      assert_equal 2, tickets_data.count
      assert_equal @ticket1.id.to_s, tickets_data[0]["id"]
      assert_equal @ticket2.id.to_s, tickets_data[1]["id"]
    end

    test "agent should see all tickets" do
      query = <<~GQL
        query {
          tickets {
            id
            title
            description
            status
            priority
          }
        }
      GQL

      result = @schema.execute(query, context: { current_user: @agent })
      assert_nil result["errors"]
      tickets_data = result.dig("data", "tickets")
      assert_equal 2, tickets_data.count # Assuming there are 2 tickets in fixtures
      assert_equal @ticket1.id.to_s, tickets_data[0]["id"]
      assert_equal @ticket2.id.to_s, tickets_data[1]["id"]
    end

    test "should return empty array if no user logged in" do
      query = <<~GQL
        query {
          tickets {
            id
          }
        }
      GQL

      result = @schema.execute(query, context: { current_user: nil })
      assert_nil result["errors"]
      assert_empty result.dig("data", "tickets")
    end
  end
end