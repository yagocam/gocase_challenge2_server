def extract_single_order_data(order)
  data = {
    Orders: {
      id: order.id,
      cart_token: order.cart_token,
      checkout_token: order.checkout_token,
      checkout_id: order.checkout_id,
      closed_at: order.closed_at,
      confirmed: order.confirmed,
      current_total_price: order.current_total_price,
      line_items: extract_line_items_data(order.line_items)
    }
  }
end

def extract_line_items_data(line_items)
  line_items.map do |line_item|
    {
      id: line_item.id,
      admin_graphql_api_id: line_item.admin_graphql_api_id,
      fulfillment_service: line_item.fulfillment_service,
      fulfillment_status: line_item.fulfillment_status,
      gift_card: line_item.gift_card,
      grams: line_item.grams,
      name: line_item.name,
      price: line_item.price,
      product_exists: line_item.product_exists,
      product_id: line_item.product_id,
      properties: extract_properties_data(line_item.properties)
    }
  end
end

def extract_properties_data(properties)
  properties.map do |property|
    {
      name: property.name,
      value: property.value
    }
  end
end

def extract_order_data(order)
  if order.is_a?(Array)
    return order.map { |item| extract_single_order_data(item) }
  else
    return extract_single_order_data(order)
  end
end
