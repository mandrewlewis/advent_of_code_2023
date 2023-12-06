# frozen_string_literal: true

require './inputs/day1_input'
include Day1Input

NUMBERS = %w[1 2 3 4 5 6 7 8 9].freeze
STRINGED_NUMBERS = %w[one two three four five six seven eight nine].freeze

def calibrate(input)
  sum = 0

  input.each do |string|
    @values = []

    populate_values(string, NUMBERS)
    populate_values(string, STRINGED_NUMBERS)

    @values.compact!
    calibrated_value = [@values[0], @values[-1]].join('').to_i

    sum += calibrated_value
  end

  sum
end

def populate_values(string, array)
  array.each_with_index do |num, i|
    substr_indexs = (0...string.length).find_all { |index| string[index, num.length] == num }
    substr_indexs.each { |sub_index| @values[sub_index] = (i + 1).to_s }
  end
end

# p calibrate(SAMPLE)
# p calibrate(SAMPLE2)
p calibrate(MAIN)
