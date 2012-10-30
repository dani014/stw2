require 'sinatra'
require 'haml'

before do
  @defeat = { rock: :scissor, paper: :rock, scissor: :paper}
  @throws = @defeat.keys
  if ($winplayer and $wincomputer == nil)
     $winplayer = 0
     $wincomputer = 0
  end
end

get '/' do
   $winplayer = 0
   $wincomputer = 0
   haml :choice
end

get '/*' do
  redirect '/'
end

post '/throw' do
  @player_throw = params[:option].to_sym

  halt(403, "You must throw one of the following: '#{@throws.join(', ')}'") unless @throws.include? @player_throw

  @computer_throw = @throws.sample

  if @player_throw == @computer_throw
    @answer = "There is a tie"
  elsif @player_throw == @defeat[@computer_throw]
    @answer = "Computer wins; #{@computer_throw} defeats #{@player_throw}"
    $wincomputer = $wincomputer + 1
  else
    @answer = "Well done. #{@player_throw} beats #{@computer_throw}"
    $winplayer = $winplayer + 1
  end
  haml :index
end
