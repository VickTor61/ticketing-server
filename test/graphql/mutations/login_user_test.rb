require "test_helper"

class Mutations::LoginUserTest < ActiveSupport::TestCase
  def setup
    @schema = TicketingSchema

    @test_user = User.create!(
      email: "test@example.com",
      first_name: "Test",
      last_name: "User",
      role: "customer",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  test "logs in user successfully with valid credentials" do
    query = <<~GQL
      mutation loginUser($input: LoginUserInput!) {
        login(input: $input) {
          user {
            id
            firstName
            lastName
            email
            role
          }
          token
        }
      }
    GQL

    variables = {
      input: {
        email: @test_user.email,
        password: "password123"
      }
    }

    result = @schema.execute(query, variables: variables)
    assert_nil result["errors"]
    login_data = result.dig("data", "login")
    assert login_data.present?

    user_data = login_data["user"]
    assert_equal @test_user.id.to_s, user_data["id"]
    assert_equal @test_user.email, user_data["email"]
    assert_equal @test_user.first_name, user_data["firstName"]
    assert_equal @test_user.last_name, user_data["lastName"]

    assert login_data["token"].present?
    assert login_data["token"].is_a?(String)
  end

  test "returns error with invalid email" do
    query = <<~GQL
      mutation loginUser($input: LoginUserInput!) {
        login(input: $input) {
          user {
            id
          }
        }
      }
    GQL

    variables = {
      input: {
        email: "nonexistent@example.com",
        password: "password123"
      }
    }

    result = @schema.execute(query, variables: variables)

    assert result["errors"].present?
    error = result["errors"].first
    assert_equal "Invalid email or password", error["message"]
  end

  test "returns error with invalid password" do
    query = <<~GQL
      mutation loginUser($input: LoginUserInput!) {
        login(input: $input) {
          user {
            id
            firstName
          }
        }
      }
    GQL

    variables = {
      input: {
        email: @test_user.email,
        password: "wrongpassword"
      }
    }

    result = @schema.execute(query, variables: variables)

    assert result["errors"].present?
    error = result["errors"].first
    assert_equal "Invalid email or password", error["message"]
  end

  test "returns error with empty email" do
    query = <<~GQL
      mutation loginUser($input: LoginUserInput!) {
           login(input: $input) {
             user {
               id
             }
           }
         }
    GQL

    variables = {
      input: {
        email: "",
        password: "password123"
      }
    }

    result = @schema.execute(query, variables: variables)

    assert result["errors"].present?
    error = result["errors"].first
    assert_equal "Invalid email or password", error["message"]
  end

  test "returns error with empty password" do
    query = <<~GQL
      mutation loginUser($input: LoginUserInput!) {
        login(input: $input) {
          user {
            id
          }
        }
      }
    GQL

    variables = {
      input: {
        email: @test_user.email,
        password: ""
      }
    }

    result = @schema.execute(query, variables: variables)

    assert result["errors"].present?
    error = result["errors"].first
    assert_equal "Invalid email or password", error["message"]
  end
end
