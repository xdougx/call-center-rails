class CreateChamadas < ActiveRecord::Migration
  def change
    create_table :chamadas do |t|
    	t.string :status
    	t.integer :central_id
    	i.integer :funcionario_id
      t.timestamps
    end
  end
end
