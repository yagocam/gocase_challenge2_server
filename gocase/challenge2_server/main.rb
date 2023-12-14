require 'sinatra'
require 'sinatra/cors'
require_relative 'routes/product'
require_relative 'routes/collection'
require_relative 'routes/order'

class MyApp < Sinatra::Base
  register Sinatra::Cors

  configure do
    enable :cross_origin
  end

  before do
    set :allow_origin, '*' # Permitir solicitações de qualquer origem
    set :allow_methods, "GET,HEAD,POST,UPDATE,DELETE"
    set :allow_headers, "content-type,if-modified-since"
    set :expose_headers, "location,link"
  end


  use Routes::Product
  use Routes::Collection
  use Routes::Order

  configure do
    set :server, :puma
  end
  set :port, 3000
end

run MyApp.run!
