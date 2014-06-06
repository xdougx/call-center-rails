class Funcionario < ActiveRecord::Base
	has_many :chamadas
	belongs_to :central

	validates :nome, presence: true

	scope :livre, -> { where(status: 'livre') }
	scope :ocupado, -> { where(status: 'ocupado') }
	
	scope :atendentes, -> { where(type: "Atendente") }
	scope :lideres, -> { where(type: "Lider") }
	scope :gerentes, -> { where(type: "Gerente") }
	

	def self.build params
		funcionario = new params

		if funcionario.valid?
			funcionario.save
			funcionario
		else
			raise Exceptions::Model.build(funcionario)
		end
	end

	def chamada_andamento
		begin
			Chamada.find(self.chamada_andamento_id)
		rescue ActiveRecord::RecordNotFound
			nil
		end
	end

	def atende_chamada chamada
		Funcionario.transaction do
			self.status = "ocupado"
			self.chamadas << chamada
			chamada.status = "em progresso"
			if chamada.valid?
				chamada.save
				self.chamada_andamento_id = chamada.id
				self.save
			else
				raise Exceptions::Model.build(chamada)
			end
		end
	end

	def finalizar_chamada
		unless self.chamada_andamento.nil?
			self.chamada_andamento.update(status:"finalizada")
			self.update(chamada_andamento_id: nil, status: "aguardando")
			
			if self.class == Atendente
				self.central.verificar_chamada_aguardando(self)
			end
		end
	end

end
