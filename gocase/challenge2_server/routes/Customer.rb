require 'sinatra'
require_relative '../helpers/shopify_api_helper'

module Routes
  class Customer < Sinatra::Base
    include ShopifyAPIHelper
    register Sinatra::Cors

    set :allow_origin, '*'
    set :allow_methods, 'GET,HEAD,POST,UPDATE,'
    set :allow_headers, 'content-type,if-modified-since'
    set :expose_headers, 'location,link'



    get '/customers' do
      limit = params[:limit] || 10
      query = <<~GRAPHQL
        {
          collections(first:#{limit}) {
            nodes {
              handle
              id
              image {
                src
                id
              }
            }
          }
        }
      GRAPHQL

      shopify_response = make_shopify_request(query)
      content_type :json
      shopify_response.to_json
    end
    put '/customer' do
      id = params[:id]
      request_body = JSON.parse(request.body.read)
      firstName = request_body['firstName']
      lastName = request_body['lastName']
      query = <<~QUERY
        mutation customerUpdate($input: CustomerInput!) {
          customerUpdate(input: $input) {
            userErrors {
              field
              message
            }
            customer {
              id
              firstName
              lastName
            }
          }
        }
      QUERY
      variables = {
        "input": {
          "id": id,
          "firstName": firstName,
          "lastName": lastName
        }
      }
      shopify_response = make_shopify_request(query, variables)
      content_type :json
      shopify_response.to_json
    end
  end
end
