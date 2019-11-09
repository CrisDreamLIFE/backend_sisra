  class SituacionAlumnoController < ApplicationController
    require 'UtilidadSituacionAlumno'

    def index
    end

    def obtenerSituacion
      obj = UtilidadSituacionAlumno.new()
      rutAlu = params[:rut]
      alumno = obj.obtenerAlumnoConRut(rutAlu)
      jsona = {"caca": 515, "pene": "sfsdf"}
      #@jsona = otro
      render :json => jsona
    end

    def getCombinatoriaRamos(ramos)
      len = ramos.length
      for i in 1..len
        
  end

