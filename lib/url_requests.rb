require 'httparty'

class UrlApi
    include HTTParty
    appId = "APPID=" + ENV["api_key"]
    URL = 'http://api.openweathermap.org/data/2.5/forecast?'+ appId+'&id='

    def requestWeather(id)
        url = URL + id
        response = HTTParty.get(url,
                    :headers =>{'Content-Type' => 'application/json'} ).parsed_response
        response
    end
end