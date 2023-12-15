require 'sinatra'
require 'shopify_api'
require 'sinatra/cors'
require_relative 'utils/utils_collection'

module Routes
  class Collection < Sinatra::Base
    register Sinatra::Cors

    session = ShopifyAPI::Auth::Session.new(
      shop: 'businesscasegocasedev.myshopify.com',
      access_token: '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'
    )
    set :allow_origin, '*'
    set :allow_methods, 'GET,HEAD,POST,UPDATE,'
    set :allow_headers, 'content-type,if-modified-since'
    set :expose_headers, 'location,link'

    before do
      headers 'Access-Control-Allow-Origin' => '*',
              'Access-Control-Allow-Methods' => 'GET, POST, PUT, DELETE, OPTIONS',
              'Access-Control-Allow-Headers' => 'Origin, Accept, Content-Type, X-Requested-With, X-CSRF-Token'
    end

    get '/collections' do
      collection = ShopifyAPI::CustomCollection.all(
        session: session
      )
      response_data = {}
      response_data['collection'] = extract_collection_data(collection)
      content_type :json
      status 200
      { status: 'success', message: 'Collection query sucessfully', collections: response_data }.to_json
    end
    delete '/collection' do
      request_body = JSON.parse(request.body.read)
      ShopifyAPI::CustomCollection.delete(
        session: session,
        id: request_body['id'],
      )
    end
    delete '/collection/:id' do
      id = params['id'].to_i
      ShopifyAPI::CustomCollection.delete(
        session: session,
        id: id,
      )
      content_type :json
      status 200
      { status: 'success', message: 'Collection removed  successfully' }.to_json
    end
    post '/collection' do
      request_body = JSON.parse(request.body.read)
      collection = ShopifyAPI::CustomCollection.new(session: session)
      collection.title = request_body['title']
      collection.image = request_body['image']
      collection.save!
      response_data = {}
      response_data['collection'] = extract_collection_data(collection)
      content_type :json
      status 200
      { status: 'success', message: 'Collection created successfully', collection: response_data }.to_json
    end
  end
end
