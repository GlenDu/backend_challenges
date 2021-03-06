# frozen_string_literal: true
require_relative 'car'
require_relative 'rental'

class Operate
  attr_accessor :cars, :rentals
  attr_reader :data 

  def initialize(data)
    @data = data
    @cars = []
    @rentals = []

    cars_data
    rentals_data
  end

  def export
    result = []
    rentals.each do |rental|
      used_cars = detect_cars(rental.car_id)
      price_by_days = used_cars.price_per_day * rental.nb_days
      total_price = (used_cars.price_per_km * rental.distance + price_by_days)
      result.push(id: rental.id, price: total_price)
    end
    {rentals: result}
  end

  private
  def cars_data
    data['cars'].each do |car|
      cars.push(car_call(car))
    end
  end

  def rentals_data
    data['rentals'].each do |rental|
      rentals.push(rental_call(rental))
    end
  end

  def car_call(data)
    ::Car.new(
      id: data['id'],
      price_per_day: data['price_per_day'],
      price_per_km: data['price_per_km']
    )
  end

  def rental_call(data)
    ::Rental.new(
      id: data['id'],
      car_id: data['car_id'],
      start_date: data['start_date'],
      end_date: data['end_date'],
      distance: data['distance']
    )
  end

  def detect_cars(id)
    detected_car = cars.detect{|car| car.id == id }
    detected_car
  end

  def detect_rentals(car_id)
    detected_rental = rentals.detect {|rental| rental.car_id == car_id }
    detected_rental
  end

end
