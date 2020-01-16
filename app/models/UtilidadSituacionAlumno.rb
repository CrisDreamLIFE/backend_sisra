class UtilidadSituacionAlumno
   include HTTParty
    
    def obtenerAlumnoConRut(rut)
        response = HTTParty.get('http://localhost:3000/alumno?alu_rut='+rut)
        @a_hash = JSON.parse(response.body) #hasheamos la respuesta para poder acceder
        #for i in (0..@a_hash.length)
         #   puts puts @a_hash[0]['rut']
        #end
    end

    def obtenerCarreraConRut(rut)
        response = HTTParty.get('http://localhost:3000/alu_Car?aca_rut='+rut)
        codigo = response[0]['aca_cod_car'].to_s 
        response2 = HTTParty.get('http://localhost:3000/carrera?car_cod='+codigo)
        @a_hash = JSON.parse(response2.body) #hasheamos la respuesta para poder acceder
        #for i in (0..@a_hash.length)
         #   puts puts @a_hash[0]['rut']
        #end
    end

    def obtenerVersionCarrera(rut)
        response = HTTParty.get('http://localhost:3000/alu_Car?alu_rut='+rut)
        @a_hash = JSON.parse(response.body) #hasheamos la respuesta para poder acceder
    end

    def obtenerIndicadores(rut)
        response = HTTParty.get('http://localhost:3000/alu_ia?aia_rut='+rut)
        @a_hash = JSON.parse(response.body) #hasheamos la respuesta para poder acceder
    end

    def obtenerTipoCarrera(cod)
        response = HTTParty.get('http://localhost:3000/tcarrera?tcr_ctip='+cod)
        @a_hash = JSON.parse(response.body) #hasheamos la respuesta para poder acceder
    end

    def obtenerEspecialidadCarrera(cod)
        response = HTTParty.get('http://localhost:3000/especialidad?esp_cod='+cod)
        @a_hash = JSON.parse(response.body) #hasheamos la respuesta para poder acceder
    end

    def obtenerMallaConCarrera(cod)
        #response = HTTParty.get('http://localhost:3000/malla?ma_ver_plan=4&ma_ccar='+cod)
        response = HTTParty.get('http://localhost:3000/malla?_sort=ma_niv&_order=desc&ma_ccar='+cod)
        @a_hash = JSON.parse(response.body) #hasheamos la respuesta para poder acceder
    end

    def obtenerversionMalla(cod)
        #response = HTTParty.get('http://localhost:3000/malla?ma_ver_plan=4&ma_ccar='+cod)
        response = HTTParty.get('http://localhost:3000/malla?_sort=ma_ver_plan&_order=desc&ma_ccar='+cod)
        @a_hash = JSON.parse(response.body) #hasheamos la respuesta para poder acceder
    end

    def obtenerCalificacionesConRut(rut)
        response = HTTParty.get('http://localhost:3000/calificacion?cal_sit_alu=A&cal_rut='+rut)
        @a_hash = JSON.parse(response.body) #hasheamos la respuesta para poder acceder
    end

    def obtenerTodasAsignaturas()
        response = HTTParty.get('http://localhost:3000/asignatura')  #asignaturaa funka
        @a_hash = JSON.parse(response.body) #hasheamos la respuesta para poder acceder
    end

    def obtenerAsignatura(cod)
        response = HTTParty.get('http://localhost:3000/asignatura?asi_cod='+cod)
        @a_hash = JSON.parse(response.body) #hasheamos la respuesta para poder acceder
    end

    def obtenerAsignaturaDeMalla(cod)
        response = HTTParty.get('http://localhost:3000/malla?ma_asign='+cod)
        @a_hash = JSON.parse(response.body) #hasheamos la respuesta para poder acceder
    end
end


