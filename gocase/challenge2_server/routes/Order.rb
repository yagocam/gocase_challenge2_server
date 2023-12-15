require 'sinatra'
require 'shopify_api'
require 'sinatra/cors'
require_relative 'utils/utils_order'

module Routes
  class Order < Sinatra::Base
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


    delete '/order/:id' do
      id = params['id'].to_i
      order = ShopifyAPI::Order.delete(
        session: session,
        id: id,
      )
      content_type :json
      status 200
      { status: 'success', message: 'Order removed  successfully' }.to_json
    end
    get '/orders' do
      request_body = JSON.parse(request.body.read)
      orders = ShopifyAPI::Order.all(
      session: session,
      status: request_body['status'],
    )
    response_data = {}
    response_data['orders'] = extract_order_data(orders)
    content_type :json
    status 200
    { status: 'success', message: 'Orders retrieve sucessfully', orders: response_data }.to_json
    end
    get '/order/:id' do
      id = params['id'].to_i

      order = ShopifyAPI::Order.find(
        session: session,
        id: id
      )
      response_data = {}
      response_data['order'] = extract_order_data(order)
      content_type :json
      status 200
      { status: 'success', message: 'Order retrieve sucessfully', order: response_data }.to_json
    end

    put '/order' do
      request_body = JSON.parse(request.body.read)
      order = ShopifyAPI::Order.new(session: session)
      order.id =  request_body['id']
      order.email = request_body['email']
      order.save!
      response_data = {}
      response_data['order'] = extract_order_data(order)
      content_type :json
      status 200
      { status: 'success', message: 'Order updated sucessfully', order: response_data }.to_json
    end

    post '/order' do

order = ShopifyAPI::Order.new(session: session)
order.line_items = [
  {
    "title" => "Big Brown Bear Boots",
    "price" => 74.99,
    "grams" => "1300",
    "quantity" => 3,
    "tax_lines" => [
      {
        "price" => 13.5,
        "rate" => 0.06,
        "title" => "State tax"
      }
    ]
  }
]
order.transactions = [
  {
    "kind" => "sale",
    "status" => "success",
    "amount" => 238.47
  }
]
order.total_tax = 13.5
order.currency = "EUR"
order.save!


content_type :json
status 200
{ status: 'success', message: 'Order paid sucessfully' }.to_json

    end
  end
end
