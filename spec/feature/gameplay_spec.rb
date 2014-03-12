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


	scenario "When nobody is playing" do
		visit "/game/show/#{@game.id}"

		expect(page).to have_button "Start Game"
	end

	scenario "when players are waiting and Start Game is pressed" do
		player1 = Player.create(:name => "Royle", :game => @game)
		player2 = Player.create(:name => "Kevin", :game => @game)

		visit "/game/show/#{@game.id}"
		expect(page).to have_button "Start Game"

		click_button "Start Game"

		@game.reload

		expect(page).not_to have_button "Start Game"
		expect(page).to have_content "Now playing"
		find("#now_playing_list").should have_content "Royle"
		find("#now_playing_list").should have_content "Kevin"
	end

	scenario "When a game is in progress and Game Over is pressed" do
		player1 = Player.create(:name => "Royle", :game => @game)
		player2 = Player.create(:name => "Kevin", :game => @game)
		@game.start!

		visit "/game/show/#{@game.id}"
		expect(page).to have_button "Game Over"

		click_button "Game Over"

		expect(page).to have_button "Start Game"
		expect(page).not_to have_content "Now Playing"
	end
end

feature "Playing a Game where winner stays" do
	before(:each) do
		DataMapper.auto_migrate!
		@game = Game.create(:name => "Darts", :player_count => 2, :winner_stays => true)
	end

	scenario "The game ending button should say Winner" do
		player1 = Player.create(:name => "Royle", :game => @game)
		player2 = Player.create(:name => "Kevin", :game => @game)
		@game.start!

		visit "/game/show/#{@game.id}"
		expect(page).to have_button "Winner"
	end
end
