# frozen_string_literal: true

require './inputs/day3_input'
include Day3Input

# AoC: Day 3
class Day3
  def initialize
    @tracked = []
    @nums = []
  end

  def decode(input, part2: false)
    @lines = input.split("\n")
    @lines.each_with_index { |line, index| parse_line(line, index) }
    numbers = @tracked.select { |obj| obj[:type] == 'number' }
    stars = @tracked.select { |obj| obj[:value] == '*' }

    part2 ? determine_gears(stars) : determine_validity(numbers)

    @nums.sum
  end

  private

  def parse_line(line, line_index)
    point = 0
    until point > line.length - 1
      if line[point] == '.'
        point += 1
        next
      end

      char = { type: 'symbol', value: line[point], line: line_index, start: point, end: point }
      if line[point] =~ /\d/
        value = get_full_num(line, point)
        char[:value] = value
        char[:type] = 'number'
        char[:end] = point + value.length - 1
        point = char[:end]
      end

      @tracked << char
      point += 1
    end
  end

  def get_full_num(line, point)
    value_chars = []
    while point <= line.length - 1 && line[point] =~ /\d/
      value_chars << line[point]
      point += 1
    end
    value_chars.join('')
  end

  def determine_validity(numbers)
    numbers.each do |num|
      line_range = [*[num[:line] - 1, 0].max..[num[:line] + 1, @lines.length - 1].min]
      char_range = [*[num[:start] - 1, 0].max..[num[:end] + 1, @lines[0].length - 1].min]
      symbols = @tracked.filter do |obj|
        obj[:type] == 'symbol' && line_range.include?(obj[:line]) && char_range.include?(obj[:start])
      end

      @nums << num[:value].to_i unless symbols.empty?
    end
  end

  def determine_gears(stars)
    stars.each do |star|
      line_range = [*[star[:line] - 1, 0].max..[star[:line] + 1, @lines.length - 1].min]
      char_range = [*[star[:start] - 1, 0].max..[star[:end] + 1, @lines[0].length - 1].min]
      adj_numbers = @tracked.filter do |obj|
        number_indexes = [*obj[:start]..obj[:end]]
        number_in_row = obj[:type] == 'number' && line_range.include?(obj[:line])
        number_in_column = char_range.any? { |char| number_indexes.include?(char) }

        number_in_row && number_in_column
      end

      @nums << adj_numbers[0][:value].to_i * adj_numbers[1][:value].to_i if adj_numbers.length == 2
    end
  end
end

day3 = Day3.new

# p day3.decode(SAMPLE)
# p day3.decode(MAIN)

# p day3.decode(SAMPLE, part2: true)
p day3.decode(MAIN, part2: true)
