# README

## Hotelzz App

### This application:
- handles guests API requests to check hotel availability from hotels registered at Hotelzz app.
- handles hotel managers (authenticated) API requests to update hotel room type prices
- Allows guests to create (via authenticated API request) a booking which makes a Stripe credit card payment in case the room is available for selected dates
- Provides an Admin Panel to check status of all current  records of the database like hotels, room types, guests, etc.

 
### Runs on:

- Rails 5.2.3

- Ruby 2.4.0

- PostgreSQL database

### Use of external gems:

- `RSpec` for automated testing together with `Fabricator`

- `Devise` for AdminPanel authentication

- `Grape` for internal API

- `JWT` for API authentication

- `Stripe` for credit card payments

- `ActiveAdmin` for admin panel

### Running the project locally:

```
# clone the project
git clone https://github.com/dantgn/hotelzz.git

# create database with sample data provided in seeds.rb
rake db:create
rake db:migrate
rake db:setup

# start the server
rails s
```

## API request examples

### Hotels availability

#### Request single hotel availability
```bash
# Request hotel#1 availability for minimum 1 guest room
curl -X GET -H "Content-type: application/json" "localhost:3000/api/v1/hotels/1/availability?check_in=2020-01-01&check_out=2020-02-01&guests=1"
```
```json
# response => status 200: OK
[
  {
    "name": "Single bed with private bath",
    "totalRooms": 4,
    "availableRooms": 4,
    "rent": "1200.0 usd"
  },
  {
    "name": "1 Queen-size bed with private bath",
    "totalRooms": 2,
    "availableRooms": 2,
    "rent": "1200.0 usd"
  },
  {
    "name": "2 King-size bed with private bath",
    "totalRooms": 1,
    "availableRooms": 1,
    "rent": "1200.0 usd"
  }
]
```
#### Request hotels availability
```bash
# Request hotels availability for minimum 2 guests room
curl -X GET -H "Content-type: application/json" "localhost:3000/api/v1/hotels/availability?check_in=2020-01-01&check_out=2020-02-01&guests=2"
```
```json
# response => status 200: OK
[
  {
    "hotelName": "The Grand Hotel Budapest",
    "roomTypes": [
      {
        "name": "1 Queen-size bed with private bath",
        "totalRooms": 2,
        "availableRooms": 2,
        "rent": "1200.0 usd"
      },
      {
        "name": "2 King-size bed with private bath",
        "totalRooms": 1,
        "availableRooms": 1,
        "rent": "1200.0 usd"
      }
    ]
  },
  {
    "hotelName": "Tarraco Hotel",
    "roomTypes": [
      {
        "name": "1 Queen-size bed with private bath",
        "totalRooms": 2,
        "availableRooms": 2,
        "rent": "1200.0 usd"
      },
      {
        "name": "2 King-size bed with private bath",
        "totalRooms": 1,
        "availableRooms": 1,
        "rent": "1200.0 usd"
      }
    ]
  }
]
```

### Room type booking

#### Request room type booking (unauthorized)
```bash
# Request hotels availability for minimum 2 guests room
curl -X POST -H "Content-type: application/json" "localhost:3000/api/v1/bookings?check_in=2020-01-01&check_out=2020-02-01&room_type_id=1"
```
```json
# response => status 401: Unauthorized
{
  "error": "401 Unauthorized"
}
```

#### Request room type booking (authorized)
```bash
# Request hotels availability for minimum 2 guests room
curl -X POST -H "Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1NTU4NjA2Njh9.jFeIPdX62LVGfPrNZRGOYguBBBb9gBeU54vheRDkGhs" -H "Content-type: application/json" "localhost:3000/api/v1/bookings?check_in=2020-01-01&check_out=2020-02-01&room_type_id=1"
```

```json
# response for valid payment => status 201: Created
{
  "id": 6,
  "guest": {
      "id": 1,
      "first_name": "John",
      "last_name": "Snow",
      "email": "guest@example.com"
  },
  "room_type": {
      "id": 1,
      "name": "Single bed with private bath",
      "occupancy_limit": 1,
      "hotel_id": 1
  },
  "check_in": "2020-01-01",
  "check_out": "2020-02-01"
}

# response for unavailable rooms => status 422: Unprocessable Entity
{
  "error": "Room Type not available for booking on selected dates"
}

# response for payment failed => status 422: Unprocessable Entity
{
  "error": "Payment transaction failed!"
}

```

### Room type price update

#### Request room type price update (unauthorized)
```bash
# Request udpdate room_type#1 
curl -X PUT -H "Content-type: application/json" "localhost:3000/api/v1/room_types/1/prices?amount=2500&month=1"
```
```json
# response => status 401: Unauthorized
{
  "error": "401 Unauthorized"
}
```

#### Request room type price update (authorized)
```bash
# Request udpdate room_type#1 
curl -X PUT -H "Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1NTU4NTQwOTN9.0bTt4KShDjn8gGkXjSw8TDZaDGLoxWgGueFJ1Bqv2NQ" -H "Content-type: application/json" "localhost:3000/api/v1/room_types/1/prices?amount=2500&month=1"
```
```json
# response => status 200: OK
{
  "id": 1,
  "room_type_id": 1,
  "amount": "2500.0",
  "currency": "usd"
}
```

## Decisions

JsonWebToken for authentication: 
- In this task I did not deal on creating/storing JWT.
- I use it for API authentication of the task requests.
- Token expiration is not considered.
- by testing needs they can be obtained using: `Authentication::JsonWebToken.encode({ used_id: 1 })`.

Stripe credit card payment:
- Stripe offers different possibilities to handle payments. I chose the straight away method for the purposes of integrating it in this task. I assumed the source token to proceed with strype payment charge is obtained in Frontend while introducing credit card details.
- I created a separate service for the payments, asking for the token, and providing stripes test as default one, from: https://stripe.com/docs/testing
- If I would have to work on this, I would probably check suscription plan possibilities.

CalculateRent / CheckAvailability
- Are implemented as a separate services in `app/services/`, extracting it from the model based on Single Responsability Principle. It also make them easier to test.

Rooom Type Prices
- I decided to create this new table in order to handle monthly prices, so every month can have different prices. It can also use different currencies (even this is not deeply implemented).

Users
- I created different tables for different type of users Guest and HotelManager, because I think they will have different columns in database, but also are very different things. AdminUsers is just there for the admin panel.
- I could have used same user table with polymorphic user_type but again, I think they might be quite different in a real app.

Grape API
- I have used Grape since I have experience on it, and made it easier to develop the app.
- If I would have more time I might have invest time on check Rails API-only.

Tests
- I used RSpec for testing, together with Fabricator (similar to FactoryBot)
- tests are splitted on `lib/`, `models`, `requests` and `services` depending on what is being tested.

Credentials
- I used Rails.application.credentials to store secrets like `stripe_api_key`.
- In case of willing to test locally stripe credit card payments, you can just edit `config/initializers/stripe` where the `api_key` is defined and replace it by your testing key.