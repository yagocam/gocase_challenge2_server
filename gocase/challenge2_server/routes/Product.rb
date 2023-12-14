require 'sinatra'
require 'shopify_api'
require 'sinatra/cors'

module Routes
  class Product < Sinatra::Base
    register Sinatra::Cors

    set :allow_origin, '*'
    set :allow_methods, 'GET,HEAD,POST,UPDATE,DELETE'
    set :allow_headers, 'content-type,if-modified-since'
    set :expose_headers, 'location,link'

    before do
      headers 'Access-Control-Allow-Origin' => '*',
              'Access-Control-Allow-Methods' => 'GET, POST, PUT, DELETE, OPTIONS',
              'Access-Control-Allow-Headers' => 'Origin, Accept, Content-Type, X-Requested-With, X-CSRF-Token'
    end

    post '/createProduct' do
      # Aqui você deve adicionar a lógica para criar um produto na Shopify
      # Utilize os parâmetros do request para obter os detalhes do produto
      # Retorne uma resposta adequada indicando o resultado da criação
      { status: 'success', message: 'Product created successfully' }.to_json
    end

    get '/products' do

      session = ShopifyAPI::Auth::Session.new(
        shop: 'businesscasegocasedev.myshopify.com',
        access_token: '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'
      )

      products = ShopifyAPI::Product.all(
        session: session
      )


      products_data = []

      products.each do |product|
        # Adicione os dados do produto ao array
        products_data << {
          title: product.title,
          id: product.id
          # Adicione outros atributos conforme necessário
        }
      end

      # Converta o array de produtos em formato JSON e envie como resposta
      products_data.to_json
      # Transforme os produtos em um formato JSON e retorne como resposta
    end
  end
end
