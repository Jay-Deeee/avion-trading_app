# Stock Trading App
A Ruby on Rails stock trading application that allows users to simulate buying and selling stocks using real-time price data. The app includes user authentication, admin approval, portfolio tracking, and transaction management.

## Features
### User Authentication (Devise)
  - User registration and login
  - Email confirmation system
  - Admin approval required before access
  - Users cannot log in unless:
    - They are approved by an admin
    - Their email is verified
### Custom Registration Flow
  1. User signs up
  2. Receives a pending approval email
  3. Admin approves the account
  4. User receives a verification email
  5. User confirms email and can log in
### Trading System
  - Buy and sell stocks using real-time prices
  - Prevents:
    - Buying without sufficient balance
    - Selling without enough shares
  - Automatically calculates:
    - Price per stock
    - Total transaction value
### Portfolio Management
  - Tracks owned stocks per user
  - Updates shares after buy/sell actions
  - Displays current holdings
### Transaction History
  - Logs all buy and sell transactions
  - Displays:
    - Symbol
    - Shares
    - Price
    - Total
    - Action type (Buy/Sell)
### Admin Panel
  - View all users
  - Approve pending users
  - Manage user accounts
  - View all transactions

## Tech Stack
  - Ruby on Rails 7
  - Devise (Authentication)
  - Sprockets + SCSS (Styling)
  - Bootstrap 5 (via CDN)
  - Font Awesome (Icons)
  - Alpha Vantage API (via RapidAPI)

# Setup Instructions
1. Clone the repository
```
git clone <your-repo-url>
cd avion-trading_app
```
2. Install dependencies
```
bundle install
```
3. Set up the database
```
rails db:create
rails db:migrate
```
4. Environment Variables
Create a `.env` file or set environment variables:
```
SMTP_USERNAME=your_email
SMTP_PASSWORD=your_password
RAPIDAPI_KEY=your_api_key
```
5. Run the server
```
bin/dev
```

## Mailer Configuration (Development)
In `config/environments/development.rb`:
```
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  address: 'smtp.gmail.com',
  port: 587,
  user_name: ENV["SMTP_USERNAME"],
  password: ENV["SMTP_PASSWORD"],
  authentication: 'plain',
  enable_starttls_auto: true
}
```

## Testing
This project uses:
  - RSpec
  - FactoryBot
Run Tests with:
```
bundle exec rspec
```
