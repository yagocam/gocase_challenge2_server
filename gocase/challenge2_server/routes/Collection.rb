require 'sinatra'
require_relative '../helpers/shopify_api_helper'

module Routes
  class Collection < Sinatra::Base
    include ShopifyAPIHelper
    register Sinatra::Cors

    set :allow_origin, "*"
    set :allow_methods, "GET,HEAD,POST,UPDATE,DELETE"
    set :allow_headers, "content-type,if-modified-since"
    set :expose_headers, "location,link"



    get '/collections' do
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
  end
end
