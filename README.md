# ticketing-server
Ticket platform
# README

This README documents the necessary steps to get the application up and running locally.

### Ruby version
- ruby-3.3.4

### System dependencies
- PostgreSQL

### Getting Started
1. **Clone the repository:**
   ```bash
   git clone git@github.com:VickTor61/ticketing-server.git
   ```
2. **Install dependencies**
   ```bash
   bundle install
   ```
3. **Create and migrate the database:**
   ```bash
   rails db:create
   rails db:migrate
   ```
4. **Run the test suite**
   ```bash
   rails test
   ```
5. **Start the server**
   ```bash
   rails s
   ```
