require 'sinatra'
require 'shopify_api'
require 'sinatra/cors'
require_relative 'utils/utils_collect'

module Routes
  class Collect < Sinatra::Base
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
    get '/collect' do
     collect =  ShopifyAPI::Collect.all(
        session: session,
      )

      response_data = {}
      response_data['collect'] = extract_collect_data(collect)
      content_type :json
      status 200
      { status: 'success', message: 'Collect retrieve sucessfully', collect: response_data }.to_json
    end
    post '/collect/add_product' do
      request_body = JSON.parse(request.body.read)
      collect = ShopifyAPI::Collect.new(session: session)
      collect.product_id = request_body['product_id']
      collect.collection_id = request_body['collection_id']
      collect.save!
      response_data = {}
      response_data['collect'] = extract_collect_data(collect)
      content_type :json
      status 200
      { status: 'success', message: 'Product add to collection successfully', collect: response_data }.to_json

    end
    delete '/collect/remove_product' do
      request_body = JSON.parse(request.body.read)
      collect = ShopifyAPI::Collect.delete(
        session: session,
        id: request_body['id'],
      )

      content_type :json
      status 200
      { status: 'success', message: 'Product removed to collection successfully' }.to_json
    end
  end
end
