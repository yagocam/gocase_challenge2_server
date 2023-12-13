require 'sinatra'
require_relative '../helpers/shopify_api_helper'

module Routes
  class Home < Sinatra::Base
    include ShopifyAPIHelper

    before do
      headers 'Access-Control-Allow-Origin' => 'http://192.168.0.5:3000',
              'Access-Control-Allow-Methods' => 'GET, POST, PUT, DELETE, OPTIONS',
              'Access-Control-Allow-Headers' => 'Origin, Accept, Content-Type, X-Requested-With, X-CSRF-Token'
    end

    get '/' do
      query = <<~GRAPHQL
        {
          products(first: 3, sortKey: CREATED_AT, reverse: true) {
            edges {
              node {
                id
                title
              }
            }
          }
        }
      GRAPHQL

      shopify_response = make_shopify_request(query)
      content_type :json
      shopify_response.to_json
    end
    get '/images' do
        query = <<~GRAPHQL
          {
            products(first: 10) {
              edges {
                node {
                  id
                  handle
                  productType
                  images(first: 10) {
                    nodes {
                      src
                    }
                  }
                }
              }
            }
          }
        GRAPHQL
  
        shopify_response = make_shopify_request(query)
        content_type :json
        shopify_response.to_json
      end
    get '/collections' do
      query = <<~GRAPHQL
      {
        collections(first: 10) {
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
  end
end
