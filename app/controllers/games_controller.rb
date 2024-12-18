require 'open-uri'

class GamesController < ApplicationController
  def new
    letters = ("A".."Z").to_a
    @random_letters = 10.times.map { letters.sample }
    session[:random_letters] = @random_letters
    session[:start_time] = Time.now
  end

  def score
    @guess = params[:guess]
    @score = 0
    @message = "Word not found"
    @time_taken = Time.now - Time.parse(session[:start_time])

    random_letters = session[:random_letters].dup
    correct = true
    @guess.upcase.each_char do |char|
      if random_letters.include?(char)
        random_letters.delete_at(random_letters.index(char))
      else
        correct = false
        break
      end
    end

    if correct
      @message = "Word is correct but not found"
      url =  "https://dictionary.lewagon.com/#{@guess.downcase}"
      r = JSON.parse(URI.parse(url).read)
      if r["found"]
        @message = "Word found"
        @score = (r["length"] / @time_taken) * 10
      end
    end
  end
end
