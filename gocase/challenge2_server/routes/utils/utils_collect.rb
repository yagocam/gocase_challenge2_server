def extract_single_collect_data(collect)
  data = {
    collect: {
      id: collect.id,
      product_id: collect.product_id,
      collection_id: collect.collection_id
    }
  }
end

def extract_collect_data(collect)
  if collect.is_a?(Array)
    return collect.map { |item| extract_single_collect_data(item) }
  else
    return extract_single_collect_data(collect)
  end
end
