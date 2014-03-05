$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../..")
require 'spec_helper'
require 'capybara'
require 'capybara/rspec'
require 'whosgotnext'

Capybara.app = Sinatra::Application

feature "Registering Game" do
	scenario "Opening the registration screen" do
		game_name = "Darts"
		visit '/game/register'

		fill_in 'name', :with => game_name
		fill_in 'player_count', :with => 2
		click_button 'Register'

		expect(page).to have_content game_name
	end
end
