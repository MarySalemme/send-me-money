require './app.rb'
require 'spec_helper'

feature 'Add new recipient' do
  scenario 'is successful' do
    authenticate
    click_button('New Recipient')
    fill_in(:name, with: 'John Doe')
    click_button('Submit')
    expect(page).to have_content('John Doe has been added successfully')
  end
end
