require 'spec_helper'

describe Exceptions::Model do
	describe "building a model exception" do
		before do
			@central = Central.new
			@central.errors.add(:nome, "can't be blank")
		end
		
		it "should build a model error" do
			exception = Exceptions::Model.build(@central).error
			expect(exception[:error]).to be_kind_of(Hash)
			expect(exception[:error]).to include(
				model: "central",
				field: "central[nome]",
				message: "can't be blank"
			)
		end

		it "should have a message" do
			exception = Exceptions::Model.build(@central)
			expect(exception).to respond_to(:message)
			expect(exception.message).to eql("can't be blank")
		end

		it "should have the model name" do
			exception = Exceptions::Model.build(@central)
			expect(exception).to respond_to(:model)
			expect(exception.model).to eql("central")
		end

	end
end