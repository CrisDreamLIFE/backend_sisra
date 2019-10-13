class CreatePesoAsignaturas < ActiveRecord::Migration[5.2]
  def change
    create_table :peso_asignaturas do |t|
      t.integer :cod_asig
      t.integer :cod_carr
      t.integer :peso

      t.timestamps
    end
  end
end
