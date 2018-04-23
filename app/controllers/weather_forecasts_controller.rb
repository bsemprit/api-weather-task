class WeatherForecastsController < ApplicationController
    require 'url_requests'
    require 'date'
    def getWeather
        id = params[:id]
        
        if(!checkId(id))
            return render :status => 404
        end

        if(id) 
            api = ::UrlApi.new()
            data = api.requestWeather(id)
            if(data["cod"] != "200") 
                return render :status => 404
            end
            list = data["list"]
            date = Date.parse list[0]["dt_txt"]
            day = {
                'max-high': 0,
                'avg-high': 0,
                'min-high': 0,
                'max-low': 0,
                'avg-low': 0,
                'min-low': 0
            }
            high = []
            low = []
            days = []
            list.each_with_index do |weather, index|
                weatherDate = Date.parse weather["dt_txt"]
                if(weatherDate == date) 
                    setTemp(weather, high, low)
                end
                if(index % 8 == 0 && index != 0 || index == (list.size - 1))
                    high = high.sort
                    low = low.sort
                    newDay = {
                        'max-high': 0,
                        'avg-high': 0,
                        'min-high': 0,
                        'max-low': 0,
                        'avg-low': 0,
                        'min-low': 0
                    }
                    setDay(newDay, high, low, days)
                    high = []
                    low = []
                    date = weatherDate
                    setTemp(weather, high, low)
                end
            end
            render json: days, status: 200
        else 
            render :status => 404
        end
    end

    def setTemp(weather, high, low) 
        maxTemp = weather["main"]["temp_max"]
        minTemp = weather["main"]["temp_min"]
        high.push(maxTemp)
        low.push(minTemp)
    end

    def setDay(newDay, high, low, days)
        newDay["max-high"] = high[-1].round(2)
        newDay["min-high"] = high[0].round(2)
        newDay["avg-high"] = (high.sum / high.size).round(2)
        newDay["max-low"] = low[-1].round(2)
        newDay["min-low"] = low[0].round(2)
        newDay["avg-low"] = (low.sum / low.size).round(2)
        days.push(newDay)
    end

    def checkId(id) 
        file = File.read('app/assets/javascripts/city.json')
        cityHash = JSON.parse(file)
        idExists = false
        id = id.to_i
        cityHash.each do |city|
            if(city["id"] == id) 
                idExists = true
            end
        end
        idExists
    end
end
