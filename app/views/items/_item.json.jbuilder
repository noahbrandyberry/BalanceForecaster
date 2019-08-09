json.extract! item, :id, :created_at, :updated_at
json.url account_item_url(item.account, item, format: :json)
