require './app.rb'
require 'spec_helper'

feature 'Make payment' do
  scenario 'is successful' do
    authenticate
    add_recipient
    click_button('Make payment')
    click_button('Choose', match: :first)
    fill_in(:amount, with: '100')
    click_button('Submit')
    expect(page).to have_content('The 100.00GBP payment you made to John Doe was successful')
  end
end
