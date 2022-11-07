require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    random_number = rand(1...25)
    @letters = ('A'...'Z').to_a.shuffle.sample(random_number)
  end

  def score
    @guess = params[:word].upcase
    opened_page = URI.open("https://wagon-dictionary.herokuapp.com/#{@guess}").read
    parsed_page = JSON.parse(opened_page)
    # @right_characters = false
    @can_build_the_word = can_build_the_word?(@guess)
    @message = build_message(parsed_page)
    @time = "You took #{(Time.now - Time.parse(params[:start_time])).round(2)} to make your guess"
  end
end

private

def can_build_the_word?(guess)
  guess.chars.all? { |character| params[:letters].count(character) >= guess.count(character) }
end

def build_message(parsed_page)
  if parsed_page['found'] && @can_build_the_word
    'You won, valid word and can be build with the given letters'
  elsif !parsed_page['found']
    'Not a valid word'
  else
    "Can't build this word with the given letters"
  end
end
