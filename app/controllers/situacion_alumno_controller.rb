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

  end

