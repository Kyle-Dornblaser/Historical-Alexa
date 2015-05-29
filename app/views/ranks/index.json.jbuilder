json.array!(@ranks) do |rank|
  json.extract! rank, :id, :traffic_rank, :domain_id
  json.url rank_url(rank, format: :json)
end
