class CreateCentrals < ActiveRecord::Migration
  def change
    create_table :centrais do |t|
    	t.string :nome
    	t.string :localizacao
    	
      t.timestamps
    end
  end
end
