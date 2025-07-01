require "test_helper"
class Mutations::LogoutTest < ActiveSupport::TestCase

  def setup
    @schema = TicketingSchema
    @customer = users(:customer)
    login_customer @customer
  end

  test "should logout logged-in customer" do
    @customer.define_singleton_method(:revoke_jwt_token!) do
      update!(jti: SecureRandom.uuid)
    end

    query = <<~GQL
      mutation Logout {
        logout
      }
    GQL

    old_jti = @customer.jti
    result = @schema.execute(query, context: { current_user: @customer, controller: @customer })
    assert_nil result["errors"]
    assert result.dig("data", "logout") == true
    @customer.reload
    assert_not_equal old_jti, @customer.jti
  end

end
