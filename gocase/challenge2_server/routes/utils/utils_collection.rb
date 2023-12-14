def extract_single_collection_data(collection)
  data = {
    id: collection.id,
    title: collection.title,
    body_html: collection.body_html,
  }
  data[:src] = collection.image['src'] if collection.image.is_a?(Hash)
  data
end

def extract_collection_data(collection)
  if collection.is_a?(Array)
    return collection.map { |item| extract_single_collection_data(item) }
  else
    return extract_single_collection_data(collection)
  end
end
