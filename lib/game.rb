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
      codes = @secret_code.chars.zip(guess.to_s.chars)
      mark<< '+' * codes.select {|x,y| x==y }.count
      minus = codes.delete_if {|x,y| x==y }.transpose
      return mark if minus.empty?
      minus[0].each do |secret| 
        unless (one_guess=minus[1].index(secret)).nil?
            mark<<'-'
            minus[1].delete_at(one_guess)
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
      f = File.open("./db/records.txt","a+")
      f<<"name:#{name}-turns:#{10-@turns}-hints:#{1-@hints}\n"
      f.close
    end
  end
end

