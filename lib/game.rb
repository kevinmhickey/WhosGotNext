require 'data_mapper'

class Game
	include DataMapper::Resource

	property :id, Serial
	property :name, String
	property :players, Integer
	property :winner_stays, Boolean

end
