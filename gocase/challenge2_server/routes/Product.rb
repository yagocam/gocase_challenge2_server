require 'sinatra'
require_relative '../helpers/shopify_api_helper'

module Routes
  class Product < Sinatra::Base
    include ShopifyAPIHelper
    register Sinatra::Cors

    set :allow_origin, "*"
    set :allow_methods, "GET,HEAD,POST"
    set :allow_headers, "content-type,if-modified-since"
    set :expose_headers, "location,link"

    before do
      headers 'Access-Control-Allow-Origin' => '*',
              'Access-Control-Allow-Methods' => 'GET, POST, PUT, DELETE, OPTIONS',
              'Access-Control-Allow-Headers' => 'Origin, Accept, Content-Type, X-Requested-With, X-CSRF-Token'
    end
    post '/createProduct' do
      query = <<~QUERY
  mutation CreateProductWithNewMedia($input: ProductInput!, $media: [CreateMediaInput!]) {
    productCreate(input: $input, media: $media) {
      product {
        id
        title
        media(first: 10) {
          nodes {
            alt
            mediaContentType
            preview {
              status
            }
          }
        }
      }
      userErrors {
        field
        message
      }
    }
  }
QUERY
    variables = {
      "input": {
        "title": "Havaianas",
        "descriptionHtml": "Edição limitada",
      },
      "media": [{"originalSource"=>"https://miscalcados.com.br/cdn/shop/files/gkpb-havaianas-oreo-2-1_0b37fd3f-1346-45f0-90c7-0dd4ba1e9d64.jpg", "alt"=>"Gray helmet for bikers", "mediaContentType"=>"IMAGE"}, {"originalSource"=>"https://www.youtube.com/watch?v=4L8VbGRibj8&list=PLlMkWQ65HlcEoPyG9QayqEaAu0ftj0MMz", "alt"=>"Testing helmet resistance against impacts", "mediaContentType"=>"EXTERNAL_VIDEO"}]
    }


        shopify_response = make_shopify_request(query,variables)
        content_type :json
        shopify_response.to_json
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
