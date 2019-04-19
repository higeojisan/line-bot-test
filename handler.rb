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
        case req.message['text']
        when '占い'
          message = bloodTypeFortuneTelling()
        else
          message = {
            type: 'text',
            text: '"占い"って言え'
          }
        end
      end
    when Line::Bot::Event::Postback
      postback_data = req['postback']['data']
      case postback_data
      when 'default'
        text = 'ちゃんと選んで'
      when 'A'
        text = '最高'
      when 'B'
        text = '最低'
      when 'O'
        text = '普通'
      when 'AB'
        text = '異常'
      end
      message = {
        type: 'text',
        text: "#{text}"
      }
    end

    response = client.reply_message(req['replyToken'], message)
    p response
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
            "type": "postback",
            "label": "View detail",
            "data": "default"
        },
        "actions": [
            {
              "type": "postback",
              "label": "A型",
              "data": "A"
            },
            {
              "type": "postback",
              "label": "B型",
              "data": "B"
            },
            {
              "type": "postback",
              "label": "O型",
              "data": "O"
            },
            {
              "type": "postback",
              "label": "AB型",
              "data": "AB"
            }
        ]
    }
  }
end