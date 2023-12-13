require 'httparty'
module ShopifyAPIHelper
    def make_shopify_request(query)
      shopify_response = HTTParty.post(
        'https://businesscasegocasedev.myshopify.com/admin/api/2023-10/graphql.json',
        headers: {
          'Content-Type' => 'application/json',
          'X-Shopify-Access-Token' => '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'
        },
        body: JSON.dump({ query: query })
      )
  
      
  
      shopify_response.parsed_response
    end
  end
  