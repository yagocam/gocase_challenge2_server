require 'sinatra'
require 'sinatra/cors'
require_relative 'routes/product'
require_relative 'routes/collection'

class MyApp < Sinatra::Base
  register Sinatra::Cors

  configure do
    enable :cross_origin
  end

  before do
    response.headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
    response.headers['Access-Control-Allow-Headers'] = 'if-modified-since,content-type,authorization'
    response.headers['Access-Control-Expose-Headers'] = 'location,link'
  end

  set :allow_origin, '*' # Permitir solicitações de qualquer origem

  use Routes::Product
  use Routes::Collection

  configure do
    set :server, :puma
  end
  set :port, 3000
end

run MyApp.run!
