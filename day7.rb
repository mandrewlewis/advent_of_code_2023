# frozen_string_literal: true

require './inputs/day7_input'
include Day7Input

TYPES = %w[
  five_kind
  four_kind
  full_house
  three_kind
  two_pair
  one_pair
  high_card
].freeze

CARDS = %w[A K Q J T 9 8 7 6 5 4 3 2].freeze

# AoC DayX
class DayX
  def compute(input, part2: false)
    hands = clean_input(input)
    hands.each { |hand| hand << get_type(hand[0]) }

    sorted_hands = []
    TYPES.each do |type|
      hands_of_type = hands.select { |hand| hand[-1] == type }
      next if hands_of_type.empty?

      sorted_hands << sort_hands(hands_of_type)
    end

    sorted_hands.flatten!(1)
    add_scores(sorted_hands)
  end

  private

  def clean_input(input)
    input.split("\n").map { |line| line.split(' ') }
  end

  def get_type(hand)
    card_counts = CARDS.map { |card| hand.scan(/#{card}/).length }.reject(&:zero?)
    case card_counts.length
    when 1
      'five_kind'
    when 2
      card_counts.any?(4) ? 'four_kind' : 'full_house'
    when 3
      card_counts.any?(3) ? 'three_kind' : 'two_pair'
    when 4
      'one_pair'
    when 5
      'high_card'
    end
  end

  def sort_hands(hands)
    hands.sort do |a, b|
      order = nil
      5.times do |i|
        next if a[0][i] == b[0][i]

        order = CARDS.index(a[0][i]) < CARDS.index(b[0][i]) ? -1 : 1 if order.nil?
      end
      order || a <=> b
    end
  end

  def add_scores(hands)
    score = 0
    hands.reverse.each_with_index do |hand, i|
      multiplier = i + 1
      score += hand[1].to_i * multiplier
    end
    score
  end
end

day = DayX.new

# p day.compute(SAMPLE)
p day.compute(MAIN)

# p day.compute(SAMPLE, part2: true)
# p day.compute(MAIN, part2: true)
