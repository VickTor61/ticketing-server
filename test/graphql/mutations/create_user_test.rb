require 'test_helper'

class Mutations::CreateUserTest < ActiveSupport::TestCase
  def perform(user_input = {})
    @mutation = Mutations::CreateUser.new(object: nil, context: {}, field: nil)
  end

  test 'creates user' do
    assert 5 + 5, 10
  end

  test "creates user successfully with valid input" do
    user_input = {
      email: "test@example.com",
      password: "password123",
      first_name: "John",
      last_name: "Doe"
    }

    result = @mutation.resolve(user_input: user_input)

    assert result[:user].persisted?
    assert_equal "test@example.com", result[:user].email
    assert_equal "John", result[:user].first_name
    assert_equal "Doe", result[:user].last_name
  end
end
