Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => 'errors#error_routing'
  get '/weather/forecasts/:id', to: 'weather_forecasts#getWeather'
  get '*path', to: 'errors#error_routing'
end
