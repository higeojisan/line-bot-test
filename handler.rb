load "vendor/bundle/bundler/setup.rb"

require 'json'
require 'line/bot'

def hello(event:, context:)
  message = {
    type: 'text',
    text: 'hello'
  }

  client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }

  response = client.reply_message("<replyToken>", message)
  p response
end
