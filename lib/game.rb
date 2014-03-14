require 'data_mapper'

class Game
	include DataMapper::Resource

	property :id, Serial
	property :name, String
	property :player_count, Integer
	property :winner_stays, Boolean, :default => false
	property :playing, Boolean, :default => false

	has n, :players

	def players_playing
		players.find_all {|player| player.state == :playing}
	end

	def players_waiting
		players.find_all {|player| player.state == :waiting}
	end

	def populate_game
		(player_count - players_playing.size).times do
			waiting_player = players.find {|player| player.state == :waiting}
			waiting_player.update(:state => :playing) unless waiting_player.nil?
		end
	end

	def game_over!
		players_playing.each do |player|
			player.state = :done
			player.save
		end
		
		populate_game

		update(:playing => false)
	end

	def game_won! winner_id
		players_playing.each do |player|
			player.update(:state => :done) unless player.id == winner_id
		end

		populate_game

		update(:playing => false)
	end
	
	def start!
		populate_game

		update(:playing => true)
	end
	
end
