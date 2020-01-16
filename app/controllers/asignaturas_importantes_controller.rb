class AsignaturasImportantesController < ApplicationController
    require 'UtilidadSituacionAlumno'

    def index
    end

    def buscarAlumnoPorRut
      obj = UtilidadSituacionAlumno.new()
      rutAlu = params[:rut]
      #Obtenemos datos personales del alumno y los guardamos en variables
      alumno = obj.obtenerAlumnoConRut(rutAlu)
	if (alumno== [])
		    render json: {
      error: "No existe"
    }, status: :not_found
	

	else
      alu_nombre = alumno[0]['alu_nombre']
      alu_paterno = alumno[0]['alu_paterno']
      alu_materno = alumno[0]['alu_materno']
	
      #obtenermos version plan 
      alu_versionTodo = obj.obtenerVersionCarrera(rutAlu)
      alu_version = alu_versionTodo[0]['aca_ver_plan']

      #indicadores del alumno
      indicesAcademicos = obj.obtenerIndicadores(rutAlu)
      ppa = indicesAcademicos[0]['aia_ppa']
      ppa_sr = indicesAcademicos[0]['aia_ppa_sr']
      ppa_car = indicesAcademicos[0]['aia_ppa_car']
      nas =indicesAcademicos[0]['aia_nas']
      nar = indicesAcademicos[0]['aia_nar']
      nass = indicesAcademicos[0]['aia_nass']

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
      #filtro weas de mas:
      lenAsig = asignaturasSF.length
      puts "len asignaturasSinFiltrar = " + lenAsig.to_s
      a = 0
      while a < lenAsig
        b = 0
        while b < lenAsig
          if !(asignaturasSF[a] == [] || asignaturasSF[b] == [] )
            if(asignaturasSF[a]['asi_nom'].parameterize == asignaturasSF[b]['asi_nom'].parameterize && a != b && a == 10000)
              puts "son iguales, comparando ver"
              puts asignaturasSF[a]['asi_nom'].parameterize
              puts asignaturasSF[b]['asi_nom'].parameterize
              ver1 = obj.obtenerAsignaturaDeMalla(asignaturasSF[a]['asi_cod'].to_s)
              ver2 = obj.obtenerAsignaturaDeMalla(asignaturasSF[b]['asi_cod'].to_s)
              if(ver1 == [])
                asignaturasSF[a] = []
                break
              end
              if(ver2 == [])
                asignaturasSF[b] = []
                break
              end
              if(ver1[0]['ma_ver_plan'] > ver2[0]['ma_ver_plan'])
                puts "mas grabde ver1"
                asignaturasSF[b] = []
              else
                asignaturasSF[a] = []
                puts "mas grabde ver2"
                break
              end
            end
          end
          b=b+1
        end
        a=a+1
      end
      #se procede con quitatr las []
      asignaturasSF.each_with_index do |element, index|
        if(element==[])
          asignaturasSF.delete(element)
        end
      end
      puts "len asignaturasSinFiltrar despues de la wea = " + asignaturasSF.length.to_s
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
      #versionMallaDesc= obj.obtenerversionMalla(alumnoCarr[0]['car_cod'].to_s)
      #versionMalla = versionMallaDesc[0]['ma_ver_plan']
      mallaUltVer=[]
      malla.each_with_index do |ele, index|
        if(ele['ma_ver_plan'] == alu_version)
          mallaUltVer.push(ele)
        end
      end
      l = mallaUltVer.length - 1   #malla sola
      nivelMax = malla[0]['ma_niv']
      #SECCION DE CODIGO DONDE SE DEJAN LAS ASIGNATURAS DEL PLAN MAS ACTUAL:
      u = 4
      mallaUltimoPlan = []
      mallaUltVer.each_with_index do |element, index|  #malla sola
        while u >= 1
          puts "ma_ver_plann = " + element['ma_ver_plan'].to_s
          puts "u = "+u.to_s
          if(element['ma_ver_plan'] == u)
            repetido = 0
            mallaUltimoPlan.each_with_index do |key, index|
              if ((key['ma_asign'] == element['ma_asign']))
                repetido = 1
                if(key['ma_ver_plan'] < element['ma_ver_plan'])
                  puts ("elimine el viejo")
                  puts "tamaño antes de eliminar de ultiplan = " + mallaUltimoPlan.length.to_s
                  mallaUltimoPlan.delete(key)
                  puts "tamaño despues de eliminar de ultiplan = " + mallaUltimoPlan.length.to_s
                  mallaUltimoPlan.push(element)
                  break
                end
              end
            end
            if(repetido == 0)
              mallaUltimoPlan.push(element)
            end
          end
          u = u - 1
        end
        u = 4
      end
      puts "largo de malla ahora = " + mallaUltimoPlan.length.to_s
      puts  "el tamaño de la malla es:"
      puts l 
      puts "malla"
      puts mallaUltVer
      array = []
      
      #filtrar malla
      #mallaUltVer.each_with_index do |element, index|   #aqui iba malal solito, y lo cambie pa probar
      #  puts element['ma_asign'].to_s
      #  if !(asignaturasCodigo.include?(element['ma_asign']))
      #    puts "1"
     #     element['ma_asign'] = 0
      #  end
      #end
      mallaFiltrada = []
      i = 0
      for i in (0..(nivelMax-1))
        mallaFiltrada.push([])
       # mallaFiltrada[i] = []
      end
      mallaUltVer.each_with_index do |element, index|   #malla sola
        if(element['ma_asign'] != 0)
          n = element['ma_niv']
          puts "element = "
          puts element
          puts "nivel = " + n.to_s
          mallaFiltrada[n-1].push(element)
        end
      end

      puts mallaFiltrada
      #Obtener calificaciones con rut
      notasAlumno = obj.obtenerCalificacionesConRut(rutAlu)
      
      #Armar hash de la malla (asignaturas, levels, peso y weas)
      mallaFinal = []  #[nivelMax]
      for i in (0..(nivelMax-1))
        aux = [mallaFiltrada[i].length-1]
        for j in (0..(mallaFiltrada[i].length-1))  # (0..(mallaFiltrada[i].length-1))
          pesoAux = -1
          #obtengo el nombre y peso
          for k in (0..(asignaturasConCT.length-1))
            a =  mallaFiltrada[i][j]['ma_asign']
            b = asignaturasConCT[k][1]
            if(a == b)
              nombreAux =  asignaturasConCT[k][0]
              peso = PesoAsignatura.where(cod_asig: asignaturasConCT[k][1], cod_carr: alumnoCarr[0]['car_cod'])
              if(peso != [])
                pesoAuxx = peso.as_json
                pesoAux = pesoAuxx[0]['peso']
                puts pesoAux
              end
            end
          end
          #obtengo las notas
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
            "peso" => pesoAux    
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
          "especialidadCarrera" => espCarr_name,
          "ppa" => ppa,
          "ppa_sr" => ppa_sr,
          "ppa_car" => ppa_car,
          "nas" => nas,
          "nar" => nar,
          "nass" => nass, 
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
  end
  

