require 'sinatra'
require 'sinatra/cors'
require_relative 'routes/home'

class MyApp < Sinatra::Base
  register Sinatra::Cors

  configure do
    enable :cross_origin
  end

  before do
    response.headers['Access-Control-Allow-Methods'] = 'GET,HEAD,POST'
    response.headers['Access-Control-Allow-Headers'] = 'if-modified-since,content-type,authorization'
    response.headers['Access-Control-Expose-Headers'] = 'location,link'
  end

  set :allow_origin, '*' # Permitir solicitações de qualquer origem

  use Routes::Home

  configure do
    set :server, :puma
  end
  set :port, 3000
end

run MyApp.run!
