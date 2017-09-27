require './app.rb'
require 'spec_helper'

feature 'Authentication' do
  scenario 'is successful' do
    visit('/')
    click_button('Authenticate')
    expect(page).to have_content('You are now authenticated')
  end
end
