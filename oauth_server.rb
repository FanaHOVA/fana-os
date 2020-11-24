require 'sinatra'
require 'dotenv/load'
require 'pocket-ruby'

enable :sessions

CALLBACK_URL = 'http://localhost:4567/oauth/callback'.freeze

Pocket.configure do |config|
  config.consumer_key = ENV['POCKET_CONSUMER_KEY']
end

get '/reset' do
  puts "GET /reset"
  session.clear
end

get "/" do
  puts "GET /"
  puts "session: #{session}"

  if session[:access_token]
    session[:access_token]
  else
    '<a href="/oauth/connect">Connect with Pocket</a>'
  end
end

get "/oauth/connect" do
  session[:code] = Pocket.get_code(:redirect_uri => CALLBACK_URL)
  new_url = Pocket.authorize_url(:code => session[:code], :redirect_uri => CALLBACK_URL)
  puts "Code: #{session[:code]}"
  redirect new_url
end

get "/oauth/callback" do
  puts "OAUTH CALLBACK"
  puts "request.url: #{request.url}"
  puts "request.body: #{request.body.read}"
  result = Pocket.get_result(session[:code], :redirect_uri => CALLBACK_URL)
  session[:access_token] = result['access_token']
  puts result['access_token']
  puts result['username']	
  # Alternative method to get the access token directly
  #session[:access_token] = Pocket.get_access_token(session[:code])
  puts session[:access_token]
  puts "session: #{session}"
  redirect "/"
end