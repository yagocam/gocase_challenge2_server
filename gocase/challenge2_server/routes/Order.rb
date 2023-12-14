require 'sinatra'
require_relative '../helpers/shopify_api_helper'

module Routes
  class Order < Sinatra::Base
    include ShopifyAPIHelper
    register Sinatra::Cors

    set :allow_origin, "*"
    set :allow_methods, "GET,HEAD,POST,UPDATE,DELETE"
    set :allow_headers, "content-type,if-modified-since"
    set :expose_headers, "location,link"



    get '/orders' do
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
    end

    put  '/order' do
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
    {"namespace" => namespace, "key" => key, "type" => "single_line_text_field", "value" => value_metafield},
    {"id" => id_metafield, "value" => price}
  ].reject { |metafield| metafield.values.any? { |v| v.nil? || v.strip.empty? } }
  shippingAddress = [{"firstName" => firstName, "lastName" => lastName, "city" => city, "address1" => address1}
].reject { |shippingAddress| shippingAddress.values.any? { |v| v.nil? || v.strip.empty? } }

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
      "input" => {
        "metafields" => metafields,
        "shippingAddress" => shippingAddress,
        "id" => id_order
      }
    }
    end
  end
end
