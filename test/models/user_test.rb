require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @customer = users(:customer)
  end

  test "should be valid with all attributes" do
    user = User.new(first_name: "Test", last_name: "User", email: "test@example.com", password: "password", password_confirmation: "password")
    assert user.valid?
  end

  test "should be invalid without a first name" do
    user = User.new(last_name: "User", email: "test@example.com", password: "password", password_confirmation: "password")
    assert_not user.valid?
    assert_includes user.errors[:first_name], "can't be blank"
  end

  test "should be invalid without a last name" do
    user = User.new(first_name: "Test", email: "test@example.com", password: "password", password_confirmation: "password")
    assert_not user.valid?
    assert_includes user.errors[:last_name], "can't be blank"
  end

  test "should be invalid without an email" do
    user = User.new(first_name: "Test", last_name: "User", password: "password", password_confirmation: "password")
    assert_not user.valid?
    assert_includes user.errors[:email], "can't be blank"
  end

  test "should have a unique email" do
    existing_user = users(:customer)
    user = User.new(first_name: "Test", last_name: "User", email: existing_user.email, password: "password", password_confirmation: "password")
    assert_not user.valid?
    assert_includes user.errors[:email], "has already been taken"
  end

  test "should have a default role of customer" do
    user = User.new(first_name: "Test", last_name: "User", email: "test@example.com", password: "password", password_confirmation: "password")
    assert_equal "customer", user.role
  end

  test "#full_name should return the full name" do
    assert_equal "john doe", @customer.full_name
  end

  test "email should be downcased and stripped" do
    user = User.new(first_name: "Test", last_name: "User", email: "  TEST@EXAMPLE.COM  ", password: "password", password_confirmation: "password")
    user.valid?
    assert_equal "test@example.com", user.email
  end
end