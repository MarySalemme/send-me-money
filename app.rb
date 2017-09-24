require 'sinatra/base'
require './lib/cool_pay.rb'

class App < Sinatra::Base
  get '/' do
    erb(:index)
  end
end
