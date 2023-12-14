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
      request_body = JSON.parse(request.body.read)
      title = request_body['title']
      description_html = request_body['descriptionHtml']
      alt = request_body['alt']
      original_source = request_body['originalSource']

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
        "title": title,
        "descriptionHtml": description_html,
      },
      "media": {"originalSource"=>original_source, "alt"=>alt, "mediaContentType"=>"IMAGE"}
    }
        shopify_response = make_shopify_request(query,variables)
        content_type :json
        shopify_response.to_json
    end
      delete '/product' do
        id = params[:id]
        query = <<~QUERY
        mutation {
          productDelete(input: {id: #{id}) {
            deletedProductId
          }
        }
      QUERY
      shopify_response = make_shopify_request(query,variables)
      content_type :json
      shopify_response.to_json
      end
      update '/product' do
        query = <<~QUERY
        mutation UpdateProductWithNewMedia($input: ProductInput!, $media: [CreateMediaInput!]) {
          productUpdate(input: $input, media: $media) {
            product {
              id
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

      input_variables = {
        "title" => title,
        "descriptionHtml" => description_html
      }.reject { |_, v| v.nil? || v.strip.empty? }

      media_variables = {
        "originalSource" => original_source,
        "alt" => alt,
        "mediaContentType" => "IMAGE"
      }.reject { |_, v| v.nil? || v.strip.empty? }

      variables = {
        "input" => input_variables,
        "media" => media_variables.empty? ? nil : [media_variables]
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
