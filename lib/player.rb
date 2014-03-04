require 'data_mapper'

class Player
	include DataMapper::Resource

	property :id, Serial
	property :name, String
	property :phone, String
end
