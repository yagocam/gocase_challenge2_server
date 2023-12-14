require 'sinatra'
require 'shopify_api'
require 'sinatra/cors'

module Routes
  class Product < Sinatra::Base
    register Sinatra::Cors

    session = ShopifyAPI::Auth::Session.new(
      shop: 'businesscasegocasedev.myshopify.com',
      access_token: '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'
    )

    set :allow_origin, '*'
    set :allow_methods, 'GET,HEAD,POST,UPDATE,DELETE'
    set :allow_headers, 'content-type,if-modified-since'
    set :expose_headers, 'location,link'

    before do
      headers 'Access-Control-Allow-Origin' => '*',
              'Access-Control-Allow-Methods' => 'GET, POST, PUT, DELETE, OPTIONS',
              'Access-Control-Allow-Headers' => 'Origin, Accept, Content-Type, X-Requested-With, X-CSRF-Token'
    end
    get '/product/:id' do
      product_id = params['id'].to_i

      product = ShopifyAPI::Product.find(
        session: session,
        id: product_id
      )

      if !product.nil?
        product_data = {
          title: product.title,
          id: product.id,
          created_at: product.created_at,
          status: product.status,
          published_at: product.published_at,
          variants: []
        }

        product.variants.each do |variant|
          product_data[:variants] << {
            id: variant.id,
            product_id: variant.product_id,
            title: variant.title,
            price: variant.price
          }
        end

        content_type :json
        product_data.to_json
      else
        # Se o produto não for encontrado, retornar um erro em JSON
        status 404
        { status: 'error', message: 'Product not found' }.to_json
      end
    end

    post '/createProduct' do
      request_body = JSON.parse(request.body.read)
      product = ShopifyAPI::Product.new(session: session)

      product.title = request_body[:title]
      product.body_html = request_body[:body_html]
      product.product_type = [:product_type]
      product.status = "active"
      product.save!
      if product.save
        content_type :json
        status 201
        product.to_json
      end

    end

    get '/products' do

      products = ShopifyAPI::Product.all(
        session: session
      )


      products_data = []

products.each do |product|
  product_data = {
    title: product.title,
    id: product.id,
    createdAt: product.created_at,
    status: product.status,
    active: product.published_at, # Verifica se há uma data de publicação
    variants: []
  }

  product.variants.each do |variant|
    product_data[:variants] << {
      id: variant.id,
      product_id: variant.product_id,
      title: variant.title,
      price: variant.price
    }
  end

  products_data << product_data
end

products_data.to_json
      # Transforme os produtos em um formato JSON e retorne como resposta
    end
  end
end
