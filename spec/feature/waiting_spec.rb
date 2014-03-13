
$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../..")
require 'spec_helper'
require 'capybara'
require 'capybara/rspec'
require 'whosgotnext'

Capybara.app = Sinatra::Application

feature "Waiting to play" do
	before(:each) do
		DataMapper.auto_migrate!
		@game = Game.create(:name => "Darts", :player_count => 2)
		@player1 = Player.create(:name => "Royle", :game => @game)
		@player2 = Player.create(:name => "Kevin", :game => @game)

		visit "/game/show/#{@game.id}"
	end

	scenario "When players are in the queue" do
		find("#waiting_list").should have_content @player1.name
		find("#waiting_list").should have_content @player2.name
	end

	scenario "Adding a new challenger" do
		new_player_name = "Kate"
		fill_in 'gotnext_name', :with => new_player_name
		click_button "Got Next"

		find("#waiting_list").should have_content new_player_name
	end
end
