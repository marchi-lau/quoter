require 'open-uri'
require 'nokogiri'
require 'sinatra'
require 'chronic'
require 'json'

module AASTOCKS
  class << self
    def RealTimeQuote(code)
      AASTOCKS::RealTimeQuote.get(code)
    end
  end
  
  module RealTimeQuote
    class << self
    def get(code)
      #[00005;S;HSBC HOLDINGS;60.450;60.400;60.450;60.500;59.850;0.600;1.003;60.500;60.050;6.46M;389.93M;5.694;4.63%;10.6164;400;1,080.13B;91.900;56.000;2012-01-11 15:48;49.157%;N]
      url = "http://www.aastocks.com/apps/data/iphone/GetRTQuoteCDF.ashx?symbol=#{code}&DataType=1&Language=en&ls=1"
      quote = Nokogiri::HTML(open(url)).children.text.split(";")
      price_now = quote[3]
      timestamp = Chronic.parse(quote[21])
      puts quote[2]
      puts price_now
      puts timestamp
      return price_now
    end
  end
end
end

get '/quote/*' do
  # matches /say/hello/to/world
  code = params[:splat][0] # => ["hello", "world"]
  price = AASTOCKS::RealTimeQuote.get(code)
  content_type :json
  {postfix: "unit", data: {value: price.to_f}}.to_json
  
end