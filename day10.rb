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
    depth = navigate(neighbors)

    if part2
      @count = 0
      count_enclosed
    end

    part2 ? @count : depth
  end

  private

  def clean_input(input)
    input.split("\n").map(&:chars)
  end

  def count_enclosed
    @lines.each_with_index do |line, l_i|
      open = false
      prev_sym = nil
      line.each_with_index do |char, c_i|
        next if char == '-' && %w[L F].include?(prev_sym)

        if %w[L 7 F J |].include?(char) && @mapped.include?([l_i, c_i])
          next if (prev_sym == 'L' && char == '7') || (prev_sym == 'F' && char == 'J')

          prev_sym = char
          open = !open
          next
        end

        @count += 1 if open
        # |,L,J,7,F all OPEN/CLOSE
        # DO NOT CLOSE PAIRS: L7, FJ
      end
    end
  end

  def initial_neighbors(start_r, start_c)
    neighbors = []
    @mapped = []
    start_r, start_c = nil
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

    replace_s(neighbors, start_r, start_c)
    neighbors.each { |coord| @mapped.push(coord[0..1]) }
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
      neighbors.each { |coord| @mapped.push(coord[0..1]) }
      depth += 1
    end
    depth
  end

  def replace_s(neighbors, start_r, start_c)
    dirs = neighbors.map { |dir| flip_dir(dir[-1]) }.sort
    @mapped.unshift([start_r, start_c])

    case dirs
    when [1, 3]
      @lines[start_r][start_c] = '-'
    when [0, 1]
      @lines[start_r][start_c] = 'L'
    when [2, 3]
      @lines[start_r][start_c] = '7'
    when [1, 2]
      @lines[start_r][start_c] = 'F'
    when [0, 3]
      @lines[start_r][start_c] = 'J'
    when [0, 2]
      @lines[start_r][start_c] = '|'
    end
  end

  def flip_dir(dir)
    dir > 1 ? dir - 2 : dir + 2
  end
end

day = Day10.new

# p day.compute(SAMPLE)
# p day.compute(SAMPLE2)
# p day.compute(MAIN)

# p day.compute(SAMPLE, part2: true)
# p day.compute(SAMPLE2, part2: true)
# p day.compute(SAMPLE3, part2: true)
p day.compute(MAIN, part2: true) # 328 too low
