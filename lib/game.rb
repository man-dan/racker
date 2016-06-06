module Codebreaker
  class Game
    attr_accessor :secret_code, :game_process, :turns, :hints
    def initialize
      @secret_code = (0...4).map { rand(1..6) }.join
      @turns = 10
      @hints = 1
      @game_process = true
    end

    def check(guess)
      mark = ''
      @turns -=1
      return '++++' if guess == @secret_code
      codes = @secret_code.chars.zip(guess.to_s.chars)
      minus = codes.delete_if {|x,y| x==y }
      mark<< '+' * (4-minus.count)
      minus.transpose[0].each do |secret| 
        unless (one_guess=minus.transpose[1].index(secret)).nil?
            mark<<'-'
            minus.transpose[1].delete_at(one_guess)
        end
      end
      mark
    end

    def hint
      return "0 hints remain" if @hints==0
      @hints -=1
      @secret_code.chars.sample
    end

    def save_game(name)
      f = File.open("./lib/views/records.erb","a+")
      f<<"name:#{name}-turns:#{10-@turns}-hints:#{1-@hints}\n"
      f.close
    end
  end
end

