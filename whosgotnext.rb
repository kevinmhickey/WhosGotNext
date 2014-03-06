$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'sinatra'
require 'lib/game'
require 'lib/player'

configure :development do 
	DataMapper.setup(:default, 'sqlite:gotnext.db')
	DataMapper.finalize
	DataMapper.auto_migrate!
end

configure :production do
	DataMapper.setup(:default, ENV['DATABASE_URL'])
	DataMapper.finalize
	DataMapper.auto_migrate!
end


get '/game/register' do
	erb :game_register
end

post '/game/register' do
	game = Game.create(params)
	redirect "/game/show/#{game.id}"
end

get '/game/show/:id' do
	@game = Game.get(params[:id])
	erb :game
end

post '/game/start/:id' do
	@game = Game.get(params[:id])
	@game.start!
	redirect "/game/show/#{params[:id]}"
end

post '/game/gameover/:id' do
	@game = Game.get(params[:id])
	@game.game_over!
	redirect "/game/show/#{params[:id]}"
end

post '/game/gotnext/:id' do
	@game = Game.get(params[:id])
	Player.create(:name => params[:gotnext_name], :game => @game)
	redirect "/game/show/#{params[:id]}"
end
