# frozen_string_literal: true

require './inputs/day9_input'
include Day9Input

# AoC Day9
class Day9
  def compute(input, part2: false)
    predictions = []
    reports = clean_input(input)

    unless part2
      reports.each do |report|
        sum = 0
        Kernel.loop do
          sum += report[-1]
          report = differences(report)
          break if report.length < 1
        end
        predictions << sum
      end
    end

    reports.each { |report| predictions << differences2(report) } if part2

    predictions.sum
  end

  private

  def clean_input(input)
    input.split("\n").map { |line| line.scan(/[-\d]+/).map(&:to_i) }
  end

  def differences(report)
    num_array = report.each_with_index.map { |num, i| report[i + 1] - num unless i == report.length - 1 }
    num_array[0...-1]
  end

  def differences2(report)
    return report[0] if report.uniq.length == 1

    diffs = report.each_with_index.map { |num, i| report[i + 1] - num unless i == report.length - 1 }
    return_val = differences2(diffs[0...-1])
    -(return_val - report[0])
  end
end

day = Day9.new

# p day.compute(SAMPLE)
# p day.compute(MAIN)

# p day.compute(SAMPLE, part2: true)
p day.compute(MAIN, part2: true)
