require "kemal"
require "uuid"

urls = {} of String => String
stats = {} of String => Int32

post "/shorten" do |env|
  original_url = env.params.json["url"].to_s
  short_code = UUID.random.to_s[0..5]
  urls[short_code] = original_url
  stats[short_code] = 0

  env.response.content_type = "application/json"
  { short_url: "http://localhost:3000/#{short_code}" }.to_json
end

get "/:short_code" do |env|
  code = env.params.url["short_code"]
  if url = urls[code]?
    stats[code] += 1
    env.redirect url
  else
    env.response.status_code = 404
    "URL not found"
  end
end

get "/stats/:short_code" do |env|
  code = env.params.url["short_code"]
  if hits = stats[code]?
    env.response.content_type = "application/json"
    { hits: hits }.to_json
  else
    env.response.status_code = 404
    "Stats not available"
  end
end

Kemal.run