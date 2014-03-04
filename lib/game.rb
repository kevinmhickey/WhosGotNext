require 'data_mapper'

class Game
	include DataMapper::Resource

	property :id, Serial
	property :name, String
	property :player_count, Integer
	property :winner_stays, Boolean

	has n, :players
end
