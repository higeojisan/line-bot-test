load "vendor/bundle/bundler/setup.rb"

require 'json'
require 'line/bot'
require 'httpclient'
require 'jsonclient'

def create_line_bot_client(line_channel_secret, line_channel_token)
  client = Line::Bot::Client.new { |config|
    config.channel_secret = line_channel_secret
    config.channel_token = line_channel_token
  }
end

def getWeatherInfo(city_id)
  client = JSONClient.new
  res = client.get("http://weather.livedoor.com/forecast/webservice/json/v1?city=#{city_id}")
  return "情報が取得出来ませんでした" unless res.status == 200
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