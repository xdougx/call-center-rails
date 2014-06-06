class Central < ActiveRecord::Base
	has_many :chamadas
	has_many :funcionarios

	validates :nome, :localizacao, presence: true


	def self.build params
		central = Central.new params

		if central.valid?
			central.save
			central
		else
			raise Exceptions::Model.build(central)
		end
	end


	def add_funcionario klass, params
		begin
			klass = Central.validate_class(klass)

			funcionario = klass.build(params)
			funcionario.status = "livre"
			self.funcionarios << funcionario
			self.save
		rescue Exceptions::Model => exception
			raise exception
		end
	end

	def recebe_chamada chamada
		begin
			chamada.central = self
			funcionario = self.seleciona_funcionario_livre

			if funcionario
				funcionario.atende_chamada(chamada) 
			else
				chamada.status = "aguardando"
				chamada.save
			end

		rescue Exceptions::Model => exception
			raise exception
		end
	end

	def seleciona_funcionario_livre
		if self.funcionarios.atendentes.livre.count > 0
			self.funcionarios.livre.first
		elsif self.funcionarios.lideres.livre.count > 0
			self.funcionarios.lideres.livre.first
		elsif	self.funcionarios.gerentes.livre.count > 0
			self.funcionarios.gerentes.livre.first
		else
			false
		end
	end

	def verificar_chamada_aguardando funcionario
		if self.chamadas.aguardando.count > 0
			chamada = self.chamadas.aguardando.first
			funcionario.atende_chamada(chamada)
		end
	end

	def self.validate_class klass
		begin
			klass = klass.to_s.capitalize.constantize

			if klass == Atendente
				Atendente
			elsif klass == Lider
				Lider
			elsif klass == Gerente
				Gerente
			else
				self.raise_validate_class_error
			end		
		rescue NameError => error
			self.raise_validate_class_error
		end
	end

	def self.raise_validate_class_error
		central = new
		central.errors.add(:funcionarios, "Esse tipo de usuário não existe")
		raise Exceptions::Model.build(central)
	end

end
