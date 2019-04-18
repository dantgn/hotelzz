module Hotels
  class CheckAvailability
    def initialize(hotel:, check_in:, check_out:, guests: nil)
      @hotel = hotel
      @check_in = check_in
      @check_out = check_out
      @guests = guests
    end

    def call
      raise Errors::AvailabilityInvalidDates if invalid_dates

      room_types_availability
    end

    private

    def invalid_dates
      @check_in > @check_out || @check_in < Date.today
    end

    def room_types_availability
      list = []

      booked = booked_room_types
      room_types = @hotel.room_types
      room_types = room_types.where('occupancy_limit >= ?', @guests) if @guests

      room_types.each do |room_type|
        list << {
          'name' => room_type.name,
          'totalRooms' => room_type.number_of_rooms,
          'availableRooms' => available_rooms(booked[room_type.id], room_type),
          'rent' => ::Hotels::CalculateRent.new(
            room_type: room_type,
            check_in: @check_in,
            check_out: @check_out
          ).call
        }
      end

      list
    end

    def booked_room_types
      bookings = @hotel.bookings.paid
      bookings = bookings.joins(:room_type).where('occupancy_limit >= ?', @guests) if @guests
      bookings.
        where(
          '(? BETWEEN check_in AND check_out) OR (? BETWEEN check_in AND check_out)',
          @check_in, @check_out
        ).
        group(:room_type_id).
        count
    end

    def available_rooms(booked_rooms, room_type)
      return room_type.number_of_rooms unless booked_rooms

      room_type.number_of_rooms - booked_rooms
    end
  end
end
