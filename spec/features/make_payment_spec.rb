require './app.rb'
require 'spec_helper'

feature 'Make payment' do
  scenario 'is successful' do
    authenticate
    click_button('Make payment')
    click_button('Make payment', match: :first)
    fill_in(:amount, with: '100')
    click_button('Submit')
    expect(page).to have_content('The payment was successful')
  end
end
