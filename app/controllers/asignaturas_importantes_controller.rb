class AsignaturasImportantesController < ApplicationController
    require 'UtilidadSituacionAlumno'

    def index
    end

    def buscarAlumnoPorRut
      obj = UtilidadSituacionAlumno.new()
      rutAlu = params[:rut]
      #Obtenemos datos personales del alumno y los guardamos en variables
      alumno = obj.obtenerAlumnoConRut(rutAlu)
      alu_nombre = alumno[0]['alu_nombre']
      alu_paterno = alumno[0]['alu_paterno']
      alu_materno = alumno[0]['alu_materno']

      #Obtenemos la carrera del estudiante
      alumnoCarr = obj.obtenerCarreraConRut(rutAlu)
      tCarr_cod = alumnoCarr[0]['car_ctip'].to_s 
      espCarr_cod = alumnoCarr[0]['car_cesp'].to_s 
      puts alumnoCarr

      #Tipo de carrera
      tCarr = obj.obtenerTipoCarrera(tCarr_cod)
      tCarr_name = tCarr[0]['tcr_nom']

      #especialidad de carrera
      espCarr = obj.obtenerEspecialidadCarrera(espCarr_cod)
      espCarr_name = espCarr[0]['esp_nom']
      jsona = {"caca": 515, "pene": "sfsdf"}

      #obtener las asignaturas
      asignaturasCodigo=[]
      asignaturasConCT=[]
      asignaturasSF = obj.obtenerTodasAsignaturas()
      #filtro de nombres:
      asignaturasSF.each_with_index do |element, index|
        aux = [2]
        aux[0] = element['asi_nom']
        aux[1] = element['asi_cod']
        asignaturasCodigo.push(element['asi_cod'])
        asignaturasConCT.push(aux)
      end
      
      #Obtener malla (asignaturas de la carrera)
      malla = obj.obtenerMallaConCarrera(alumnoCarr[0]['car_cod'].to_s)
      l = malla.length - 1
      puts  "el tamaño de la malla es:"
      puts l 
      array = []
      nivelMax = malla[0]['ma_niv']
      #filtrar malla
      malla.each_with_index do |element, index|
        #puts element['ma_asign'].to_s
        if !(asignaturasCodigo.include?(element['ma_asign']))
         # puts "1"
          element['ma_asign'] = 0
        end
      end
      mallaFiltrada = [nivelMax]
      for i in (0..(nivelMax-1))
        mallaFiltrada[i] = []
      end
      puts mallaFiltrada
      malla.each_with_index do |element, index|
        if(element['ma_asign'] != 0)
          n = element['ma_niv']
          mallaFiltrada[n-1].push(element)
        end
      end

      #Obtener calificaciones con rut
      notasAlumno = obj.obtenerCalificacionesConRut(rutAlu)
      
      #Armar hash de la malla (asignaturas, levels, peso y weas)
      mallaFinal = [nivelMax]
      for i in (0..(nivelMax-1))
        aux = [mallaFiltrada[i].length-1]
        for j in (0..(mallaFiltrada[i].length-1))
          #obtengo el nombre
          for k in (0..(asignaturasConCT.length-1))
            a =  mallaFiltrada[i][j]['ma_asign']
            b = asignaturasConCT[k][1]
            if(a == b)
              nombreAux =  asignaturasConCT[k][0]
            end
          end
          #obtengo el nombre
          encontrado = 0
          for h in (0..(notasAlumno.length-1))
            a =  mallaFiltrada[i][j]['ma_asign']
            b = notasAlumno[h]['cal_asign']
            if(a == b)
              encontrado = 1
              situacionAux =  notasAlumno[h]['cal_sit_alu']
            end
          end
          if(encontrado == 0)
            situacionAux = "NA"
          end
          aux[j] = {
            "nombreAsig" => nombreAux,
            "nivel" => mallaFiltrada[i][j]['ma_niv'],
            "situacion" => situacionAux,
            "peso" => 0
            }
          mallaFinal[i] = aux
        end
      end
      malla_hash = {
        datosAlumno: {
          "nombreAlu" => alu_nombre,
          "paternoAlu" => alu_paterno,
          "maternoAlu" => alu_materno,
          "tipoCarrera"=> tCarr_name,
          "especialidadCarrera" => espCarr_name
        },
        malla: mallaFinal
      }
      #malla.each_with_index do |element, index|
       # for i in (0..l)
          
       # end
      #end

      render :json => malla_hash
    end

  end

