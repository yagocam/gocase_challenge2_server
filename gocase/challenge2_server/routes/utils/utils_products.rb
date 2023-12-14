def extract_product_data(product)
  {
    id: product.id,
    title: product.title,
    body_html: product.body_html,
    product_type: product.product_type,
    status: product.status,
    images: extract_images_data(product.images)
  }
end

def extract_images_data(images)
  images.map do |image|
    {
      id: image.id,
      src: image.src
    }
  end
end

def extract_variant_data(variant)
  {
    id: variant.id,
    product_id: variant.product.id,
    option1: variant.option1,
    image_id: variant.image_id,
    price: variant.price,
    inventory_quantity: variant.inventory_quantity
  }
end
