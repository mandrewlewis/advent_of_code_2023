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
CARDS2 = %w[A K Q T 9 8 7 6 5 4 3 2 J].freeze

# AoC Day7
class Day7
  def compute(input, part2: false)
    hands = clean_input(input)
    hands.each { |hand| hand << get_type(hand[0], part2) }

    sorted_hands = []
    TYPES.each do |type|
      hands_of_type = hands.select { |hand| hand[-1] == type }
      next if hands_of_type.empty?

      sorted_hands << sort_hands(hands_of_type, part2)
    end

    sorted_hands.flatten!(1)
    add_scores(sorted_hands)
  end

  private

  def clean_input(input)
    input.split("\n").map { |line| line.split(' ') }
  end

  def get_type(hand, part2)
    cards = part2 ? CARDS2 : CARDS
    card_counts = cards.map { |card| hand.scan(/#{card}/).length }

    if part2 && !card_counts[-1].zero?
      joker_count = card_counts.pop
      max_index = card_counts.index(card_counts.max)
      card_counts[max_index] += joker_count
      card_counts << 0
    end

    card_counts.reject!(&:zero?)
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

  def sort_hands(hands, part2 = false)
    cards = part2 ? CARDS2 : CARDS

    hands.sort do |a, b|
      order = nil
      5.times do |i|
        next if a[0][i] == b[0][i]

        order = cards.index(a[0][i]) < cards.index(b[0][i]) ? -1 : 1 if order.nil?
      end
      order || 0
    end
  end

  def add_scores(hands)
    score = 0
    hands.reverse.each_with_index { |hand, i| score += hand[1].to_i * (i + 1) }
    score
  end
end

day = Day7.new

# p day.compute(SAMPLE)
# p day.compute(MAIN)

# p day.compute(SAMPLE, part2: true)
p day.compute(MAIN, part2: true)
