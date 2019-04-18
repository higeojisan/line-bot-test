load "vendor/bundle/bundler/setup.rb"

require 'json'
require 'line/bot'

def weather(event:, context:)
  client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }

  message = {
    type: 'text',
    text: 'push message'
  }
  client.push_message(ENV["MY_LINE_USER_ID"], message)
end
