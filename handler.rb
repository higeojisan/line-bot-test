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

  body = event["body"]
  requests = client.parse_events_from(body)
  requests.each do |req|
    case req
    when Line::Bot::Event::Message
      case req.type
      when Line::Bot::Event::MessageType::Text
        response = client.reply_message(req['replyToken'], message)
        p response
      end
    end
  end
end
