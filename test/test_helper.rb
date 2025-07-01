ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "faker"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def login_agent(agent)
      login(agent)
    end

    def login_customer(customer)
      login(customer)
    end

    private

    def login(user)
      @schema = TicketingSchema

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
          email: user.email,
          password: "password123"
        }
      }

      result = @schema.execute(query, variables: variables)
      result.to_h["data"]["login"]
    end
  end
end
