require "test_helper"

module Queries
  class MeTest < ActiveSupport::TestCase
    def setup
      @schema = TicketingSchema
      @customer = users(:customer)
      @agent = users(:agent)
    end

    test "should return current user if logged in" do
      query = <<~GQL
        query {
          me {
            id
            firstName
            lastName
            email
            role
          }
        }
      GQL

      result = @schema.execute(query, context: { current_user: @customer })
      assert_nil result["errors"]
      assert_equal @customer.id.to_s, result.dig("data", "me", "id")
      assert_equal @customer.first_name, result.dig("data", "me", "firstName")
      assert_equal @customer.last_name, result.dig("data", "me", "lastName")
      assert_equal @customer.email, result.dig("data", "me", "email")
      assert_equal @customer.role, result.dig("data", "me", "role")
    end

    test "should return nil if no user logged in" do
      query = <<~GQL
        query {
          me {
            id
          }
        }
      GQL

      result = @schema.execute(query, context: { current_user: nil })
      assert_nil result["errors"]
      assert_nil result.dig("data", "me")
    end
  end
end