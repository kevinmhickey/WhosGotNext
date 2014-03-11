$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../..")
require 'spec_helper'
require 'capybara'
require 'capybara/rspec'
require 'whosgotnext'

Capybara.app = Sinatra::Application

feature "Registering Game" do
	scenario "Opening the registration screen" do
		game_name = "Golden Tee"
		visit '/game/register'

		fill_in 'name', :with => game_name
		fill_in 'player_count', :with => 4
		click_button 'Register'

		expect(page).to have_content game_name
	end

	scenario "Registering a game where winner stays" do
		game_name = "Darts"
		visit '/game/register'

		fill_in 'name', :with => game_name
		fill_in 'player_count', :with => 2
		check 'winner_stays'
		click_button 'Register'

		expect(page).to have_content game_name
	end
end
