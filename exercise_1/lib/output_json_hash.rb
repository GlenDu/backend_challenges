# frozen_string_literal: true
require_relative 'operate'

class OutputJsonHash

  def print_json
    {"rentals"=> 
    (0..2).map do |index|
      {
      "id"=> rental_prices[1][index],
      "price"=> rental_prices[0][index]
      }
    end
    }
    #File.write('./data/output.json', JSON.dump(call_operate))
  end

  private

  def rental_prices
    x = call_operate
    prices_array =
    [[
      x[0][1] * x[0][0] + x[0][2] * x[0][3],
      x[1][1] * x[0][0] + x[0][2] * x[1][3],
      x[2][1] * x[1][0] + x[1][2] * x[2][3]
    ],
    [
      x[0][4],
      x[1][4],
      x[2][4]
    ]]
  end

  def call_operate
    Operate.new.compute_array
  end

end