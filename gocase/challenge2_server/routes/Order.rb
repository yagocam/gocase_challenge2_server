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
    get '/order' do
      limit = params[:limit] || 10
      query = <<~QUERY
        query {
          orders(first: 10) {
            edges {
              node {
                id
                displayFinancialStatus
                name
              }
            }
          }
        }
      QUERY

      shopify_response = make_shopify_request(query)
      content_type :json
      shopify_response.to_json
    end

    delete '/order' do
      id = params[:id]
      query = <<~QUERY
        mutation draftOrderDelete($input: DraftOrderDeleteInput!) {
          draftOrderDelete(input: $input) {
            deletedId
          }
        }
      QUERY
      variables = {
        "input": {
          "id": id
        }
      }
      shopify_response = make_shopify_request(query, variables)
      content_type :json
      shopify_response.to_json
    end

    put '/order' do
      request_body = JSON.parse(request.body.read)
      namespace = request_body['namespace']
      key = request_body['key']
      type = request_body['type']
      price = request_body['price']
      value_metafield = request_body['value_metafield']
      type_metafield = request_body['type_metafield']
      id_metafield = request_body['id_metafield']
      id_order = request_body['id_order']
      firstName = request_body['firstName']
      lastName = request_body['lastName']
      city = request_body['city']
      address1 = request_body['address1']

      metafields = [
        { 'namespace' => namespace, 'key' => key, 'type' => 'single_line_text_field', 'value' => value_metafield },
        { 'id' => id_metafield, 'value' => price }
      ].reject { |metafield| metafield.values.any? { |v| v.nil? || v.strip.empty? } }
      shippingAddress = [{ 'firstName' => firstName, 'lastName' => lastName, 'city' => city,
                           'address1' => address1 }].reject do |shippingAddress|
        shippingAddress.values.any? do |v|
          v.nil? || v.strip.empty?
        end
      end

      query = <<~QUERY
        mutation updateOrderMetafields($input: OrderInput!) {
          orderUpdate(input: $input) {
            order {
              id
              metafields(first: 3) {
                edges {
                  node {
                    id
                    namespace
                    key
                    value
                  }
                }
              }
            }
            userErrors {
              message
              field
            }
          }
        }
      QUERY
      variables = {
        'input' => {
          'metafields' => metafields,
          'shippingAddress' => shippingAddress,
          'id' => id_order
        }
      }
      shopify_response = make_shopify_request(query, variables)
      content_type :json
      shopify_response.to_json
    end
  end
end
