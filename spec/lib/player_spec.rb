$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'player'
require 'data_mapper'

describe Player do
	before(:all) do
		DataMapper::Model.raise_on_save_failure = true
		DataMapper.setup(:default, 'sqlite::memory:')
		DataMapper.finalize
	end

	before(:each) do
		DataMapper.auto_migrate!
	end

	it "should have one player in the repository after registration" do
		game = Game.create
		Player.create(:name => "Big Kevin", :phone => "+15127960235", :game => game)
		Player.all.size.should eq(2)
	end

	it "should default to the waiting state on creation" do
		player = Player.new
		player.state.should eq(:waiting)
	end
end
