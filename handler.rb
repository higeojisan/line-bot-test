load "vendor/bundle/bundler/setup.rb"

require 'json'
require 'line/bot'

def hello(event:, context:)
  client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }

  body = event["body"]

  ## 署名の検証
  request_header = event["headers"]
  signature = request_header["X-Line-Signature"]
  return unless client.validate_signature(body, signature)

  requests = client.parse_events_from(body)
  requests.each do |req|
    case req
    when Line::Bot::Event::Message
      case req.type
      when Line::Bot::Event::MessageType::Text
        message = {
          type: 'text',
          text: "#{req.message['text']}"
        }
        message = bloodTypeFortuneTelling() if req.message['text'] == '占い'
        response = client.reply_message(req['replyToken'], message)
        p response
      end
    end
  end
end

def bloodTypeFortuneTelling()
  message = {
    "type": "template",
    "altText": "This is a buttons template",
    "template": {
        "type": "buttons",
        "title": "血液型占い",
        "text": "血液型を選んでね",
        "defaultAction": {
            "type": "message",
            "label": "View detail",
            "text": "default"
        },
        "actions": [
            {
              "type": "message",
              "label": "A型",
              "text": "A"
            },
            {
              "type": "message",
              "label": "B型",
              "text": "B"
            },
            {
              "type": "message",
              "label": "O型",
              "text": "O"
            },
            {
              "type": "message",
              "label": "AB型",
              "text": "AB"
            }
        ]
    }
  }
end