class AddColumnChamadaAndamentoIdToFuncionario < ActiveRecord::Migration
  def change
    add_column :funcionarios, :chamada_andamento_id, :integer
  end
end
