class AddColumnStatusToFuncionario < ActiveRecord::Migration
  def change
    add_column :funcionarios, :status, :string
  end
end
