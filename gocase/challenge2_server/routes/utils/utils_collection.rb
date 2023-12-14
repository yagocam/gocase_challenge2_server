def extract_single_collection_data(collection)
  data = {
    collection: {
      id: collection.id,
      title: collection.title,
    }
  }
  if collection.image.is_a?(Hash)
    data[:collection][:src] = collection.image['src']
  end
  data
end

def extract_collection_data(collection)
  if collection.is_a?(Array)
    return collection.map { |item| extract_single_collection_data(item) }
  else
    return extract_single_collection_data(collection)
  end
end
