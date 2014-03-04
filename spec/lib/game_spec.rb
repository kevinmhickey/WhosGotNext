$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'game'
require 'data_mapper'

describe Game do
	before(:all) do
		DataMapper::Model.raise_on_save_failure = true
		DataMapper.setup(:default, 'sqlite::memory:')
		DataMapper.finalize
		DataMapper.auto_migrate!
	end

	it "should have one game in the repository after registration" do
		Game.create(:name => "Golden Tee", :player_count => 4, :winner_stays => false)
		Game.all.size.should eq(1)
	end

	it "should be able to contain players" do
		game = Game.create(:name => "Golden Tee", :player_count => 4, :winner_stays => false)
		player1 = Player.create(:name => "Player 1", :game => game)
		player2 = Player.create(:name => "Player 2", :game => game)

		game.players.size.should eq(2)
		player1.game.should eq(game)
		player2.game.should eq(game)
	end

	it "should know a game is in progress if any players are playing" do
		game = Game.create(:name => "Golden Tee", :player_count => 4, :winner_stays => false)
		player1 = Player.create(:name => "Player 1", :game => game)
		player2 = Player.create(:name => "Player 2", :state => :playing, :game => game)
		
		game.in_progress?.should eq(true)
	end

	it "should know a game is not in progress if no players are playing" do
		game = Game.create(:name => "Golden Tee", :player_count => 4, :winner_stays => false)
		player1 = Player.create(:name => "Player 1", :game => game)
		player2 = Player.create(:name => "Player 2", :state => :playing, :game => game)
		player2.state = :done
		player2.save
		
		game.in_progress?.should eq(false)
	end
end

