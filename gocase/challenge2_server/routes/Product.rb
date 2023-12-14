require 'sinatra'
require 'shopify_api'
require 'sinatra/cors'
require_relative 'utils/utils_products'
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

    put '/product/:id' do
      request_body = JSON.parse(request.body.read)
      product_id = params['id'].to_i
      response_data = {}
      product = ShopifyAPI::Product.new(session: session)
      product.id = product_id
      product.title = request_body['title']
      product.body_html = request_body['body_html'] if request_body['body_html']
      product.status = request_body['status'] if request_body['status']
      if request_body['images'].is_a?(Array)
        product.images = request_body['images']
      elsif request_body['clear_images']
        product.images = []
      end
      if product.save!
        response_data['product'] = extract_product_data(product)
        content_type :json
        status 201
        { status: 'success', message: 'Product updated successfully', product: response_data }.to_json
      else
        status 500
        { status: 'error', message: 'Failed to update product', errors: product.errors.full_messages }.to_json
      end
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
        status 404
        { status: 'error', message: 'Product not found' }.to_json
      end
    end

    post '/create_product' do
      request_body = JSON.parse(request.body.read)
      response_data = {}
      product = ShopifyAPI::Product.new(session: session)
      product.title = request_body['title']
      product.body_html = request_body['body_html']
      product.product_type = request_body['product_type']
      product.status = request_body['status']
      product.images = request_body['images'] if request_body['images']

      if product.save!
        response_data['product'] = extract_product_data(product)
        if request_body['variants'] && request_body['variants'].is_a?(Array)
          request_body['variants'].each_with_index do |variant_data, index|
            variant = ShopifyAPI::Variant.new(session: session)
            variant.product_id = product.id
            variant.option1 = variant_data['title']
            variant.image_id = product.images[index].id if product.images[index].id
            variant.price = variant_data['price']
            variant.inventory_quantity = variant_data['inventory_quantity']
            variant.save!
          end
        end

        response_data['variants'] << extract_variant_data(variant)
        content_type :json
        status 201
        { status: 'success', message: 'Product created successfully', product: response_data }.to_json
      else
        status 500
        { status: 'error', message: 'Failed to create product', errors: product.errors.full_messages }.to_json
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
          body_html: product.body_html,
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
    end
  end
end
