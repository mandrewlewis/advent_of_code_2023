# frozen_string_literal: true

require './inputs/day10_input'
include Day10Input

CODES = {
  '|' => [0, 2],
  '-' => [1, 3],
  'L' => [0, 1],
  'J' => [0, 3],
  '7' => [2, 3],
  'F' => [1, 2],
  '.' => [],
  'S' => [0, 1, 2, 3]
}

# AoC Day10
class Day10
  def compute(input, part2: false)
    @lines = clean_input(input)
    neighbors = initial_neighbors(nil, nil)
    navigate(neighbors)
  end

  private

  def clean_input(input)
    input.split("\n").map(&:chars)
  end

  def initial_neighbors(start_r, start_c)
    neighbors = []
    @lines.each_with_index do |line, i|
      next unless line.include?('S')

      start_r = i if start_r.nil?
      start_c = line.index('S') if start_c.nil?
      break
    end

    if !start_r.zero? && CODES[@lines[start_r - 1][start_c]].include?(2)
      neighbors << [start_r - 1, start_c, 2]
    end
    if start_r != @lines.length - 1 && CODES[@lines[start_r + 1][start_c]].include?(0)
      neighbors << [start_r + 1, start_c, 0]
    end
    if !start_c.zero? && CODES[@lines[start_r][start_c - 1]].include?(1)
      neighbors << [start_r, start_c - 1, 1]
    end
    if start_c != @lines[start_r].length - 1 && CODES[@lines[start_r][start_c + 1]].include?(3)
      neighbors << [start_r, start_c + 1, 3]
    end

    neighbors
  end

  def get_next(coords)
    symbol = @lines[coords[0]][coords[1]]
    CODES[symbol].each do |dir|
      next if dir == coords[-1]

      case dir
      when 0
        return [coords[0] - 1, coords[1], flip_dir(dir)]
      when 1
        return [coords[0], coords[1] + 1, flip_dir(dir)]
      when 2
        return [coords[0] + 1, coords[1], flip_dir(dir)]
      when 3
        return [coords[0], coords[1] - 1, flip_dir(dir)]
      end
    end
  end

  def navigate(neighbors)
    depth = 1
    until neighbors[0][0..1] == neighbors[1][0..1]
      neighbors.map! do |coords|
        get_next(coords)
      end
      depth += 1
    end
    depth
  end

  def flip_dir(dir)
    dir > 1 ? dir - 2 : dir + 2
  end
end

day = Day10.new

# p day.compute(SAMPLE1)
# p day.compute(SAMPLE2)
p day.compute(MAIN)

# p day.compute(SAMPLE, part2: true)
# p day.compute(MAIN, part2: true)
