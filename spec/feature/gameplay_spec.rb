$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../..")
require 'spec_helper'
require 'capybara'
require 'capybara/rspec'
require 'whosgotnext'

Capybara.app = Sinatra::Application

feature "Playing a Game" do
	before(:each) do
		DataMapper.auto_migrate!
		@game = Game.create(:name => "Darts", :player_count => 2)
	end


	scenario "When nobody is playing the Start Game button should exist" do
		visit "/game/show/#{@game.id}"

		expect(page).to have_button "Start Game"
	end

	scenario "When players are waiting and Start Game is pressed screen should show game in progress" do
		player1 = Player.create(:name => "Royle", :game => @game)
		player2 = Player.create(:name => "Kevin", :game => @game)

		visit "/game/show/#{@game.id}"
		expect(page).to have_button "Start Game"

		click_button "Start Game"

		expect(page).not_to have_button "Start Game"
		expect(page).to have_content "Now playing"
		expect(page).to have_content "Royle"
		expect(page).to have_content "Kevin"
	end
end

