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
        session: session,
      )
      response_data = {}
      response_data['collection'] = extract_collection_data(collection)
      content_type :json
      status 200
      { status: 'success', message: 'Product updated successfully',collections: response_data }.to_json
    end
  end
end
