# frozen_string_literal: true
require_relative 'car'
require_relative 'rental'

class ReadOperate
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
    km_price = new_car_data.first.price_per_km
    new_rental.each_with_index do |rental,i|
      final_price = km_price * rental.distance + adjusted_prices[i].round
      result.push(id: rental.id, price: final_price)
    end
    {rentals: result}
  end

  private
  def adjusted_prices
    total_price = []
    fixed_price = new_car_data.first.price_per_day
    new_rental.each do |rental|
      if rental.nb_days == 1
        total_price.push(fixed_price)
      elsif rental.nb_days < 4 && rental.nb_days > 1
        total_price.push(fixed_price * 0.9 * (rental.nb_days - 1) + fixed_price)
      elsif rental.nb_days < 11 && rental.nb_days > 4
        total_price.push(fixed_price * (1 + 0.9 * 3) + fixed_price * 0.7 * (rental.nb_days - 4))
      elsif rental.nb_days > 10
        total_price.push(fixed_price * (1 + 0.9 * 3 + 0.7 * 6 + ((rental.nb_days - 10)* 0.5)))
      end
    end
    total_price
  end

  def new_car_data
    cars.each do |car|
      detect_rental(car.id)
    end.flatten
  end

  def new_rental
    rentals.each do |rental|
      detect_car(rental.car_id)
    end.flatten    
  end

  def rentals_data
    data['rentals'].each do |rental|
      rentals.push(call_rentals(rental))
    end
  end

  def cars_data
    data['cars'].each do |car|
      cars.push(call_cars(car))     
    end
  end

  def call_cars(data)
    ::Car.new(
      id: data['id'],
      price_per_day: data['price_per_day'],
      price_per_km: data['price_per_km']
    )
  end

  def call_rentals(data)
    ::Rental.new(
      id: data['id'],
      car_id: data['car_id'],
      start_date: data['start_date'],
      end_date: data['end_date'],
      distance: data['distance']
    )
  end

  def detect_car(car_id)
    dtected_cars = cars.detect {|car| car.id == car_id}
    dtected_cars
  end

  def detect_rental(id)
    detected_rentals = rentals.detect {|rental| rental.id == id}
    detected_rentals
  end

end
