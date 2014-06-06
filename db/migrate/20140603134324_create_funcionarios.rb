class CreateFuncionarios < ActiveRecord::Migration
  def change
    create_table :funcionarios do |t|
      t.string :nome
      t.string :type
      t.integer :central_id

      t.timestamps
    end
  end
end
