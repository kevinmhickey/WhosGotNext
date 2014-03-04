$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'game'

describe Game do
	it "should have one game in the repository after registration" do
		Game.register(:name => "Golden Tee", :players => 4, :winner_stays => false)
		Game.get_all.size.should eq(1)
	end
end
