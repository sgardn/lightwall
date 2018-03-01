require 'rubygems'
require 'sinatra'
require 'twilio-ruby'

busy = false

post '/sms' do
  body = params['Body'].downcase
  twiml = Twilio::TwiML::MessageResponse.new do |resp|
    if body.length > 24
      resp.message(body: 'Please use FEWER than 25 characters!')
    elsif busy
      resp.message(body: 'Try again in a few seconds')
    else
      busy = true
      save = body

      case rand(3)
      when 0
        `sudo python fill.py`
      when 1
        `sudo python burst.py`
      else
        `sudo python flash.py`
      end

      save.each_char do |char|
        show(char)
      end

      resp.message(body: 'Check the wall ;)')

      busy = false
    end
  end

  twiml.to_s
end

def show(character)
  value = character.ord - 97
  if value >= 0 && value < 25
    puts "should show: #{character}"
    `sudo python #{character}.py`
  else
    puts "not showing: #{character}"
  end
end
