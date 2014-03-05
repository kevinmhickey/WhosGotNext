require 'data_mapper'

class Game
	include DataMapper::Resource

	property :id, Serial
	property :name, String
	property :player_count, Integer
	property :winner_stays, Boolean

	has n, :players

	def in_progress?
		players.any? {|player| player.state == :playing}
	end

	def players_playing
		players.find_all {|player| player.state == :playing}
	end

	def players_waiting
		players.find_all {|player| player.state == :waiting}
	end

	def game_over!
		players_playing.each do |player|
			player.state = :done
			player.save
		end
	end
	
	def start!
		player_count.times do 
			waiting_player = players.find {|player| player.state == :waiting}
			waiting_player.state = :playing
			waiting_player.save
		end
	end
	
end
