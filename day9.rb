# frozen_string_literal: true

require './inputs/day9_input'
include Day9Input

# AoC Day9
class Day9
  def compute(input, part2: false)
    predictions = []
    reports = clean_input(input)

    reports.each { |report| predictions << differences(report, part2) }

    predictions.sum
  end

  private

  def clean_input(input)
    input.split("\n").map { |line| line.scan(/[-\d]+/).map(&:to_i) }
  end

  def differences(report, part2)
    return report[0] if report.uniq.length == 1

    diffs = report.each_with_index.map { |num, i| report[i + 1] - num unless i == report.length - 1 }
    return_val = differences(diffs[0...-1], part2)
    part2 ? -(return_val - report[0]) : report[-1] + return_val
  end
end

day = Day9.new

# p day.compute(SAMPLE)
# p day.compute(MAIN)

# p day.compute(SAMPLE, part2: true)
p day.compute(MAIN, part2: true)
