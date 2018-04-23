require 'rails_helper'

RSpec.describe WeatherForecastsController, type: :controller do
    describe 'GET /weather/forecasts/:id' do
        it 'returns weather forecast for 5 days' do
            get :getWeather, :params => { id: 4180439 }
            expect(response.body).not_to be_empty
        end

        it 'returns status code 200' do
            get :getWeather, :params => { id: 4180439 }
            expect(response).to have_http_status(200)
        end
    
        context 'when the record does not exist' do
            it 'returns a status code of 404' do
                get :getWeather, :params => { id: 111 }
                expect(response).to have_http_status(404)
            end
        end
    
      end
end
