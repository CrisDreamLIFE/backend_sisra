Rails.application.routes.draw do
  get 'asignaturas_importantes/index', format: :json 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'asignaturas_importantes/buscarAlumnoPorRut/:rut', to: 'asignaturas_importantes#buscarAlumnoPorRut', format: :json 

  get 'situacion_alumno/:rut', to: 'situacion_alumno#obtenerAlumnoConRut', format: :json 

  namespace :api do
    resources :peso_asignaturas, format: :json    #api/peso_asignaturas
  end
end
