# frozen_string_literal: true
require_relative '../main'
require_relative '../lib/car'

RSpec.describe Car do
  subject(:car_object) { described_class.new(id: 1, price_per_day: 1, price_per_km: 1) }
  describe '#initialize' do
    it 'testing initialize of Car' do
      expect(car_object.id).to eq 1
      expect(car_object.price_per_day).to eq 1
      expect(car_object.price_per_km).to eq 1
    end
  end
end