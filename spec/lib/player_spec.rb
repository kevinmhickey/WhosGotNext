$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'player'
require 'data_mapper'

describe Player do
	before(:all) do
		DataMapper.setup(:default, 'sqlite::memory:')
		DataMapper.finalize
		DataMapper.auto_migrate!
	end

	it "should have one player in the repository after registration" do
		Player.create(:name => "Big Kevin", :phone => "+15127960235")
		Player.all.size.should eq(1)
	end
end
