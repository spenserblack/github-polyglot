# frozen_string_literal: true

# Creates an adder that can add one number to another
#
# @param [Integer] num The number for adding
class Adder
  def initialize(num)
    @num = num
  end

  # Adds a number
  #
  # @param [Integer] other The other number to add
  # @return [Integer] The addition result
  def add(other)
    @num + other
  end
end
