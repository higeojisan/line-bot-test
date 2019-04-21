load "vendor/bundle/bundler/setup.rb"

require 'json'
require 'line/bot'
require 'lib/util'

def weather(event:, context:)
  client = create_line_bot_client(ENV["LINE_CHANNEL_SECRET"], ENV["LINE_CHANNEL_TOKEN"])

  weatherInfo = getWeatherInfo(ENV['CITY_ID'])

  message = {
    type: 'text',
    text: "#{weatherInfo}"
  }
  client.push_message(ENV["MY_LINE_USER_ID"], message)
end