require 'sinatra/base'
require 'sinatra/config_file'
require './models/cool_pay.rb'
require 'json'

class App < Sinatra::Base
  register Sinatra::ConfigFile

  config_file './config.yml'
  API_USER = settings.coolpay_username
  API_KEY = settings.coolpay_apikey

  configure(:development) { set :session_secret, 'something' }
  enable :sessions

  get '/' do
    erb(:index)
  end

  post '/home' do
    @coolpay = CoolPay.new
    auth_response = @coolpay.authenticate(API_USER, API_KEY)
    authentication_json = JSON.parse(auth_response.body)
    session[:token] = authentication_json['token']
    redirect '/home'
  end

  get '/home' do
    @token = session[:token]
    erb(:home)
  end

  get '/recipients/new' do
    erb(:'/recipients/new')
  end

  post '/recipients' do
    @token = session[:token]
    @coolpay = CoolPay.new
    new_recipient_response = @coolpay.add_recipient(params[:name], @token)
    new_recipient_json = JSON.parse(new_recipient_response.body)
    session[:new_recipient] = new_recipient_json['recipient']['name']
    redirect '/recipients'
  end

  get '/recipients' do
    @token = session[:token]
    @coolpay = CoolPay.new
    recipients_response = @coolpay.list_recipients(@token)
    recipients_json = JSON.parse(recipients_response.body)
    @recipients = recipients_json['recipients']
    erb(:'/recipients/show')
  end

  get '/payments/new' do
    session[:id] = params[:id]
    erb(:'/payments/new')
  end

  post '/payments' do
    @recipient_id = session[:id]
    @token = session[:token]
    @coolpay = CoolPay.new
    new_payment_response = @coolpay.make_payment(params[:amount], @recipient_id, @token)
    new_payment_json = JSON.parse(new_payment_response.body)
    session[:new_payment] = new_payment_json['payment']['status']
    redirect '/payments'
  end

  get '/payments' do
    @new_payment = session[:new_payment]
    erb(:'/payments/show')
  end
end
