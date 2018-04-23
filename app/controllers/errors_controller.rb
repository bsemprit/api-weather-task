class ErrorsController < ApplicationController
    def error_routing
        render :status => 404
    end
end
