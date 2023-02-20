json.extract! card, :id, :card_title, :created_at, :updated_at
json.url card_url(card, format: :json)
