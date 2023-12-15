def extract_single_order_data(order)
  data = {
    order: {
      id: order.id,
      cart_token: order.cart_token,
      checkout_token: order.checkout_token,
      checkout_id: order.checkout_id,
      closed_at: order.closed_at,
      confirmed: order.confirmed,
      current_total_price: order.current_total_price,
      total_order: order.total_order,
      name: order.name,
      email: order.email
    }
  }
end


def extract_order_data(order)
  if order.is_a?(Array)
    return order.map { |item| extract_single_order_data(item) }
  else
    return extract_single_order_data(order)
  end
end
