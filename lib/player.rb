require 'data_mapper'

class Player
	include DataMapper::Resource

	property :id, Serial
	property :name, String
	property :phone, String
	property :state, Enum[ :waiting, :playing, :done, :canceled ], :default => :waiting

	belongs_to :game
end
