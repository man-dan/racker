require "erb"
require "./lib/game"

class Racker
  def self.call(env)
    new(env).response.finish
  end
   
  def initialize(env)
    @request = Rack::Request.new(env)
    @game = game
  end

  def response
    case @request.path
    when "/" then Rack::Response.new(render("index.html.erb"))
    when "/replay" then replay
    when '/check' then check 
    when '/hints' then hints
    when '/save'  then save
    else Rack::Response.new("Not Found", 404)
    end
  end


  def replay
    @request.session[:game] = Codebreaker::Game.new
    Rack::Response.new do |response|
      @request.session[:guess] = ''
      @request.session[:mark] = ''
      @request.session[:name] = ''
      @request.session[:hint] = ''
      response.redirect("/")
    end
  end

  def check
    Rack::Response.new do |response|
        @request.session[:guess] = @request.params['guess']
        @request.session[:mark] = @game.check(guess) if guess.match(/^[1-6]{4}$/)
        response.redirect('/')
    end
  end

  def hints
    Rack::Response.new do |response|
      @request.session[:hint] = @game.hint
      response.redirect("/")
    end    
  end

  def save
    Rack::Response.new do |response|
        @request.session[:name] = @request.params['name']
        @game.save_game(name)
        response.redirect('/')
    end
  end
  
  def win
   return true if guess== @game.secret_code
  end

  def lose
    return true if @game.turns == 0
  end  

  def name
    @request.session[:name]
  end

  def game
    @request.session[:game] ||= Codebreaker::Game.new
  end

  def mark
    @request.session[:mark]
  end

  def guess
    @request.session[:guess]
  end

  
  def hint
    @request.session[:hint]
  end

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end
end