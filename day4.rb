# frozen_string_literal: true

require './inputs/day4_input'
include Day4Input

# AoC Day4
class Day4
  def initialize
    @nums = []
    @card_count = 0
  end

  def compute(input, part2: false)
    @original_cards = input.split("\n")
    @original_cards.each_with_index do |card, index|
      winners, given = card.split('|')
      @original_cards[index] = {
        id: index,
        winners: winners[winners.index(':')..].scan(/\d+/),
        given: given.scan(/\d+/)
      }
    end

    @all_wins = determine_winners
    @all_wins.each { |wins| @nums << 2**(wins - 1) unless wins.zero? }

    determine_duplicates if part2

    part2 ? @card_count : @nums.sum
  end

  private

  def determine_winners(cards = @original_cards)
    all_wins = []
    cards.each do |card|
      wins = 0
      card[:given].each { |num| wins += 1 if card[:winners].include?(num) }
      all_wins << wins
    end
    all_wins
  end

  def determine_duplicates
    orginal_count = @original_cards.length
    card_ids = []
    @original_cards.each { |card| card_ids << card[:id] }

    orginal_count.times do |i|
      numbered_group = card_ids.select { |id| id == i }
      @card_count += numbered_group.length
      card_ids.reject! { |id| id == i }
      numbered_group.each do |_|
        dup_indexs = if @all_wins[i].zero?
                       []
                     else
                       [*[i + 1, orginal_count - 1].min..[i + @all_wins[i], orginal_count - 1].min]
                     end
        dup_indexs.each do |card_id|
          card_ids << card_id
        end
      end
    end
  end

  def create_copies
  end
end

day4 = Day4.new

# p day4.compute(SAMPLE_INPUT)
# p day4.compute(MY_INPUT)

# p day4.compute(SAMPLE_INPUT, part2: true)
p day4.compute(MY_INPUT, part2: true)
