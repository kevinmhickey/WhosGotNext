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
		player1 = @game.got_next :name => "Royle"
		player2 = @game.got_next :name => "Kevin"

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
		player1 = @game.got_next :name => "Royle"
		player2 = @game.got_next :name => "Kevin"
		@game.start!

		visit "/game/show/#{@game.id}"
		expect(page).to have_button "Winner"

		click_button "Winner"

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
		player1 = @game.got_next :name => "Royle"
		player2 = @game.got_next :name => "Kevin"
		@game.start!

		visit "/game/show/#{@game.id}"
		expect(page).to have_button "Winner"
	end

	scenario "The winner is a player in the next game" do
		player1 = @game.got_next :name => "Royle"
		winner = @game.got_next :name => "Kevin"
		gotnext = @game.got_next :name => "Jim"
		@game.start!

		visit "/game/show/#{@game.id}"
		expect(page).to have_button "Winner"

		choose "#{winner.id}_winner"
		click_button "Winner"

		find("#now_playing_list").should have_content winner.name
	end
end
