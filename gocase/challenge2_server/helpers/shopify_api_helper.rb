require 'httparty'

module ShopifyAPIHelper
  def make_shopify_request(query, variables = {})
    body = { query: query }
    body[:variables] = variables unless variables.empty?

    shopify_response = HTTParty.post(
      'https://businesscasegocasedev.myshopify.com/admin/api/2023-10/graphql.json',
      headers: {
        'Content-Type' => 'application/json',
        'X-Shopify-Access-Token' => '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'
      },
      body: JSON.dump(body)
    )

    shopify_response.parsed_response
  end
end
