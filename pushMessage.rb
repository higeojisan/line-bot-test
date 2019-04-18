load "vendor/bundle/bundler/setup.rb"

require 'json'
require 'line/bot'
require 'httpclient'
require 'jsonclient'

def getWeatherInfo(city_id)
  client = JSONClient.new
  res = client.get("http://weather.livedoor.com/forecast/webservice/json/v1?city=#{city_id}")
  status = res.status
  body = res.body.to_h
  forecasts = body['forecasts']
  result = "明日の天気\n\n"
  link = body['link']
  forecasts.each do |forecast|
    if forecast['dateLabel'] == '明日'
      result += forecast['telop'] + "\n"
      max_temp = forecast['temperature']['max']['celsius']
      min_temp = forecast['temperature']['min']['celsius']
      result += "最高気温: #{max_temp}" + "\n"
      result += "最低気温: #{min_temp}" + "\n"
      result += "\n" + link
    end
  end
  result
end

def weather(event:, context:)
  client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }

  weatherInfo = getWeatherInfo(ENV['CITY_ID'])

  message = {
    type: 'text',
    text: "#{weatherInfo}"
  }
  client.push_message(ENV["MY_LINE_USER_ID"], message)
end