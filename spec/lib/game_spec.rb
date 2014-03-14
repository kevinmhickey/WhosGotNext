$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'game'
require 'data_mapper'

describe Game do
	before(:all) do
		DataMapper::Model.raise_on_save_failure = true
		DataMapper.setup(:default, 'sqlite::memory:')
		DataMapper.finalize
	end

	before(:each) do
		DataMapper.auto_migrate!
	end

	it "should have one game in the repository after registration" do
		Game.create(:name => "Golden Tee", :player_count => 4, :winner_stays => false)
		Game.all.size.should eq(1)
	end

	it "should be able to contain players" do
		game = Game.create(:name => "Golden Tee", :player_count => 4, :winner_stays => false)
		player1 = game.players.create(:name => "Player 1")
		player2 = game.players.create(:name => "Player 2")

		game.players.size.should eq(2)
		player1.game.should eq(game)
		player2.game.should eq(game)
	end

	it "should know which players are waiting" do
		game = Game.create(:name => "Solitare", :player_count => 1, :winner_stays => false)
		player1 = Player.create(:name => "Player 1", :game => game)
		player2 = Player.create(:name => "Player 2", :game => game)
		playing = Player.create(:name => "Playing", :game => game, :state => :playing)

		game.players_waiting.should eq([player1, player2])
	end

	describe "in progress" do
		before(:each) do 
			@game = Game.create(:name => "Solitare", :player_count => 1, :winner_stays => false, :playing => false)
			@player1 = Player.create(:name => "Player 1", :game => @game)
			@player2 = Player.create(:name => "Player 2", :game => @game)
			@game.start!
			@game.reload
		end

		it "should know a game is in progress if it has been started" do
			@game.playing?.should eq(true)
		end

		it "should know a game is not in progress if it is over" do
			@game.game_over!
			@game.playing?.should eq(false)
		end

		it "should list only player 1 as playing" do
			@game.players_playing.should eq([@player1])
		end
	end

	describe "Stopping a game" do
		before(:each) do 
			@game = Game.create(:name => "Darts", :player_count => 2, :winner_stays => false)
			@player1 = Player.create(:name => "Player 1", :state => :playing, :game => @game)
			@player2 = Player.create(:name => "Player 2", :state => :playing, :game => @game)
			@waiter = Player.create(:name => "Waiter", :state => :waiting, :game => @game)
		end

		it "should mark all playing players as done when the game is over" do
			@game.game_over!

			@player1.reload
			@player2.reload

			@player1.state.should eq(:done)
			@player2.state.should eq(:done)

		end
	end

	describe "Starting a game" do
		before(:each) do 
			@game = Game.create(:name => "Darts", :player_count => 2, :winner_stays => false)
			@players = []
			@players << Player.create(:name => "Kevin", :state => :waiting, :game => @game)
			@players << Player.create(:name => "Cad", :state => :waiting, :game => @game)
			@players << Player.create(:name => "Jimmy", :state => :waiting, :game => @game)

			@game.start!

			@players.each { |player| player.reload }
		end

		it "should set the next two players to playing on game start" do
			@players[0].state.should eq(:playing)
			@players[1].state.should eq(:playing)
		end

		it "should not change the state of other players" do
			@players[2].state.should eq(:waiting)
		end

		it "should contain an updated list of players playing" do
			@game.players_playing.should eq([@players[0], @players[1]])
		end
	end

	describe "where winner stays" do
		it "should no longer be in progress when someone has won" do
			@game = Game.create(:name => "Darts", :player_count => 2, :winner_stays => true)
			@player1 = Player.create(:name => "Player 1", :state => :waiting, :game => @game)
			@player2 = Player.create(:name => "Player 2", :state => :waiting, :game => @game)
			@waiter = Player.create(:name => "Waiter", :state => :waiting, :game => @game)
			@game.start!
			
			@game.game_won! @player1.id

			@game.playing.should eq(false)
		end

		it "should keep the winner as playing when a game is won" do
			@game = Game.create(:name => "Darts", :player_count => 2, :winner_stays => true)
			@player1 = Player.create(:name => "Player 1", :state => :playing, :game => @game)
			@player2 = Player.create(:name => "Player 2", :state => :playing, :game => @game)
			@waiter = Player.create(:name => "Waiter", :state => :waiting, :game => @game)

			@game.game_won! @player1.id

			@game.players_playing.should include(@player1)
		end

		it "should have a full roster of players when the game is won" do
			@game = Game.create(:name => "Darts", :player_count => 2, :winner_stays => true)
			@player1 = Player.create(:name => "Player 1", :state => :playing, :game => @game)
			@player2 = Player.create(:name => "Player 2", :state => :playing, :game => @game)
			@waiter = Player.create(:name => "Waiter", :state => :waiting, :game => @game)

			@game.game_won! @player1.id

			@game.players_playing.size.should eq(2)
			@game.players_playing.should include(@player1)
			@game.players_playing.should include(@waiter)
		end
	end
end

