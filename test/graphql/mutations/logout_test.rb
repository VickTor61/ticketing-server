# require "test_helper"
#
# class Mutations::LogoutTest < ActiveSupport::TestCase
#
#   def setup
#     @schema = TicketingSchema
#     @customer = users(:customer)
#     login_customer @customer
#   end
#
#   test "should logout logged-in customer" do
#     @customer.define_singleton_method(:revoke_jwt_token!) do
#       update!(jti: SecureRandom.uuid)
#     end
#
#     query = <<~GQL
#       mutation Logout {
#         logout
#       }
#     GQL
#
#     result = @schema.execute(query, context: { current_user: @customer })
#     binding.irb
#     assert_nil result["errors"]
#     # Add assertions based on what your logout mutation returns
#     # For example:
#     # assert result.dig("data", "logout") == true
#   end
#
# end
