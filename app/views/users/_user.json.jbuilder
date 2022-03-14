json.extract! user, :id, :name, :dob, :gender, :status, :created_at, :updated_at
json.url user_url(user, format: :json)
