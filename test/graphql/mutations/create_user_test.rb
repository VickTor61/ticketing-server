require "test_helper"

class Mutations::CreateUserTest < ActiveSupport::TestCase
  def setup
    @schema = TicketingSchema
  end

  test "creates user successfully with valid input" do
    query = <<~GQL
      mutation CreateUser($input: CreateUserInput!) {
        createUser(input: $input) {
          user {
            id
            email
            firstName
            lastName
            role
          }
        }
      }
    GQL

    variables = {
      input: {
        userInput: {
          email: "test@example.com",
          password: "password123",
          passwordConfirmation: "password123",
          firstName: "John",
          lastName: "Doe",
          role: "customer"
        }
      }
    }

    result = @schema.execute(query, variables: variables)

    assert_nil result["errors"]
    user_data = result.dig("data", "createUser", "user")
    assert user_data.present?
    assert_equal "test@example.com", user_data["email"]
    assert_equal "John", user_data["firstName"]
    assert_equal "Doe", user_data["lastName"]
    assert_equal "customer", user_data["role"]
  end

  test "returns error message when user creation fails" do
    # Create existing user first
    existing_user = User.create!(
      email: "existing@example.com",
      password: "password123",
      password_confirmation: "password123",
      first_name: "Existing",
      last_name: "User",
      role: "customer"
    )

    query = <<~GQL
      mutation CreateUser($input: CreateUserInput!) {
        createUser(input: $input) {
          user {
            id
            email
          }
        }
      }
    GQL

    variables = {
      input: {
        userInput: {
          email: existing_user.email,
          password: "password123",
          passwordConfirmation: "password123",
          role: "customer",
          firstName: "Jane",
          lastName: "Doe"
        }
      }
    }

    result = @schema.execute(query, variables: variables)

    assert result["errors"].present?
    error = result["errors"].first
    assert_equal "Error creating account.", error["message"]
  end
end
