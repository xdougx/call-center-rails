require 'spec_helper'

RSpec.describe Funcionario, :type => :model do
	describe "creating a new employee" do
		describe "validating the necessary attributes and creating" do
			context "when has some errors" do
				before { @funcionario = Funcionario.new }
				
				it { should validate_presence_of(:nome).with_message("can't be blank") }
				it { expect(@funcionario).not_to be_valid }
				it { expect { @funcionario.build({}) }.to raise_error { Exceptions::Model } }
			end
    
			context "when has no errors" do
				before { @funcionario = Funcionario.new(nome: "Pedro Vasconcelos") }
				subject { @funcionario }
    
				its(:nome) { should be_present }
				it "should be created when save"  do
					expect { Funcionario.build(nome: "Pedro Vasconcelos") }.to change { Funcionario.all.count }.by(1)
				end
			end
		end
	end

	describe "answering a call and finishing" do
		context "when receives a call" do
			before do
				@central = Central.new(nome: "England", localizacao: "London")
				@central.add_funcionario(:atendente, nome: Faker::Name.name)
				@funcionario = @central.funcionarios.first
			end

			it "should answer the call" do
				@chamada = Chamada.new
				@funcionario.atende_chamada(@chamada)
				
				expect(@funcionario.status).to eql("ocupado")
				expect(@funcionario.chamada_andamento).to eql(@chamada)
				expect(@chamada.status).to eql("em progresso")
			end

			context "finishing a call" do
				before do
					@central = Central.new(nome: "England", localizacao: "London")
					@central.add_funcionario(:atendente, nome: Faker::Name.name)
					@funcionario = @central.funcionarios.first
				end

				it "should finish and get status waiting" do
					@chamada = Chamada.new
					@funcionario.atende_chamada(@chamada)
					@funcionario.finalizar_chamada
					@chamada.reload

					expect(@funcionario.status).to eql("aguardando")
					expect(@chamada.status).to eql("finalizada")
				end

				it "should finish and get another call" do
					@chamada_1 = Chamada.new
					@funcionario.atende_chamada(@chamada_1)

					@chamada_2 = Chamada.new
					@central.recebe_chamada(@chamada_2)
					@funcionario.finalizar_chamada
					@chamada_2.reload

					expect(@funcionario.status).to eql("ocupado")
					expect(@chamada_2.status).to eql("em progresso")
				end
			end
		end
	end

end
