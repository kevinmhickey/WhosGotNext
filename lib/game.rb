require 'data_mapper'

class Game
	include DataMapper::Resource

	property :id, Serial
	property :name, String
	property :player_count, Integer
	property :winner_stays, Boolean

	has n, :players

	def in_progress?
		players.any? { |player| player.state == :playing }
	end

	def players_playing
		players.find_all { |player| player.state == :playing }
	end

	def game_over!
		players_playing.each do |player|
			player.state = :done
			player.save
		end
	end
	
end
