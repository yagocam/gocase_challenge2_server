require 'sinatra'
require_relative '../helpers/shopify_api_helper'

module Routes
  class Product < Sinatra::Base
    include ShopifyAPIHelper

    before do
      headers 'Access-Control-Allow-Origin' => 'http://192.168.0.5:3000',
              'Access-Control-Allow-Methods' => 'GET, POST, PUT, DELETE, OPTIONS',
              'Access-Control-Allow-Headers' => 'Origin, Accept, Content-Type, X-Requested-With, X-CSRF-Token'
    end

    
    get '/products' do
      limit = params[:limit] || 10
        query = <<~GRAPHQL
          {
            products(first: #{limit}) {
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
  end
end
