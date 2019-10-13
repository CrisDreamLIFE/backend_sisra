class Api::PesoAsignaturasController < ApplicationController
    PER_PAGE_RECORDS = 9
    
    def index
        @pesoAsignaturas_paginated = PesoAsignatura.all
        render json: @pesoAsignaturas_paginated
    end    
end
