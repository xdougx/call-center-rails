require 'spec_helper'

RSpec.describe Central, :type => :model do
	describe "creating a central" do
		describe "validating the required fields" do
			context "when is not valid" do
				before { @central = Central.new }

				it { should validate_presence_of(:nome).with_message("can't be blank") }
				it { should validate_presence_of(:localizacao).with_message("can't be blank") }
				it { expect(@central).not_to be_valid }
				it { expect { Central.build({}) }.to raise_error(Exceptions::Model) }
			end

			context "when is valid" do
				before { @central = Central.new(nome: "Matriz", localizacao: "São Paulo") }
				subject { @central }

				its(:nome) { should be_present }
				its(:localizacao) { should be_present }
				it "should persist a new central into DB"  do
					expect { @central.save }.to change { Central.all.count }.by(1)
				end
			end

		end
	end

	describe "adding a new employee" do
		before { @central = Central.build(nome: "China", localizacao: "Hong Kong") }

		it "should add a new employee" do
			expect { @central.add_funcionario(:atendente, nome: Faker::Name.name) }.to change { @central.funcionarios.count }.by(1)
		end

		it "should be kind of Atendente" do
			@central.add_funcionario(:atendente, nome: Faker::Name.name)
			@funcionario = @central.funcionarios.last

			expect(@funcionario).to be_kind_of(Atendente) 
		end

		it "should be kind of Lider" do
			@central.add_funcionario(:lider, nome: Faker::Name.name)
			@funcionario = @central.funcionarios.last
			
			expect(@funcionario).to be_kind_of(Lider) 
		end

		it "should be kind of Gerente" do
			@central.add_funcionario(:gerente, nome: Faker::Name.name)
			@funcionario = @central.funcionarios.last
			
			expect(@funcionario).to be_kind_of(Gerente) 
		end

		it "should raise an Exceptions::Model" do			
			expect{ @central.add_funcionario(:nao_existe, nome: Faker::Name.name) }.to raise_error(Exceptions::Model)
		end

		it "should set the new employee to be ready for a new call" do
			@central.add_funcionario(:atendente, nome: Faker::Name.name)
			@funcionario = @central.funcionarios.first
			expect(@funcionario.status).to match(/livre/)
		end

	end

	describe "receiving a call" do
		context "selecting a free employee" do
			before { @central = Central.new(nome: "SBC", localizacao: "Ferrazopolis") }

			it "should select an Antendente if has any one free" do
				@central.add_funcionario(:atendente, nome: Faker::Name.name)
				expect(@central.seleciona_funcionario_livre).to be_kind_of(Atendente)
			end

			it "should select an Lider if doesn't any Atendente free" do
				@central.recebe_chamada(Chamada.new)
				@central.add_funcionario(:lider, nome: Faker::Name.name)

				expect(@central.seleciona_funcionario_livre).to be_kind_of(Lider)
			end

			it "should select an Gerente if doesn't have Antendente and Lider free" do
				@central.recebe_chamada(Chamada.new)
				@central.add_funcionario(:gerente, nome: Faker::Name.name)

				expect(@central.seleciona_funcionario_livre).to be_kind_of(Gerente)
			end
		end

		context "receiving the call" do
			before { @central = Central.new(nome: "South Korea", localizacao: "Gangnam") }
			
			it "should receive a call and change count" do
				@central.add_funcionario(:atendente, nome: Faker::Name.name)
				expect { @central.recebe_chamada(Chamada.new) }.to change { @central.chamadas.count }.by(1)
			end

			it "should receive true if its all ok" do
				@central.add_funcionario(:atendente, nome: Faker::Name.name)
				expect(@central.recebe_chamada(Chamada.new)).to be true
			end

			it "should have at least one employee in busy status" do
				@central.add_funcionario(:atendente, nome: Faker::Name.name)
				@central.recebe_chamada(Chamada.new)
				expect(@central.funcionarios.ocupado.count).to be > 0
			end

			it "should put the call in the wait queue" do
				@chamada = Chamada.new
				@central.recebe_chamada(@chamada)
				expect(@chamada.status).to eql("aguardando")
			end
		end

		context "checking if has any call in the wait queue" do
			before { @central = Central.new(nome: "Australia", localizacao: "Canberra") }

			it "should redirect a call to an Atendente if have any waiting call" do
				@funcionario = Atendente.build(nome: Faker::Name.name, status: 'livre')
				@chamada = Chamada.new
				@central.recebe_chamada(@chamada)
				@central.funcionarios << @funcionario

				expect { @central.verificar_chamada_aguardando(@funcionario) }
					.to change { @funcionario.chamada_andamento }
					.from(nil).to(@chamada)
			end

		end
	end
end