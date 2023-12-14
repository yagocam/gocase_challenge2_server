require 'sinatra'
require 'sinatra/cors'
require 'openssl'
require_relative 'routes/product'
require_relative 'routes/collection'
require_relative 'routes/order'
require_relative 'routes/customer'

class MyApp < Sinatra::Base
  register Sinatra::Cors

  configure do
    enable :cross_origin
  end
  ShopifyAPI::Context.setup(
    api_key: '7c7b0ff217bb75f7516936cd0a747844',
    api_secret_key: '4781408f07cd7b3d63975db5add4b940',
    host: '<businesscasegocasedev.myshopify.com>',
    scope: 'read_analytics, read_customers, write_customers, read_order_edits, write_order_edits, read_inventory, write_inventory, write_product_feeds, read_product_feeds, write_product_listings, read_product_listings, write_products, read_products, write_publications, read_publications, write_online_store_pages, read_online_store_pages, write_orders, read_orders, write_draft_orders, read_draft_orders, read_shopify_payments_bank_accounts, read_shopify_payments_accounts, read_shopify_payments_payouts, read_payment_customizations',
    is_embedded: true, # Set to true if you are building an embedded app
    api_version: '2023-10', # The version of the API you would like to use
    is_private: false # Set to true if you have an existing private app
  )
  before do
    set :allow_origin, '*' # Permitir solicitações de qualquer origem
    set :allow_methods, 'GET,HEAD,POST,UPDATE,DELETE'
    set :allow_headers, 'content-type,if-modified-since'
    set :expose_headers, 'location,link'
  end

  use Routes::Product
  use Routes::Collection
  use Routes::Order
  use Routes::Customer

  configure do
    set :server, :puma
  end
  set :port, 3000
end

run MyApp.run!
