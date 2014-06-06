module Exceptions
	class Model < Base
	
		# for model errors this method build a hash with all necessary information
		# @return [String] json string
		def error
			{ 
				error: { 
					model: self.model, 
					field: "#{self.model}[#{self.object.errors.first[0]}]", 
					message: "#{self.object.errors.first[1]}"
				} 
			}
		end

		# return what model is
		# @return [String]
		def model
			self.object.class.name.demodulize.tableize.singularize
		end

		# return the error message
		# @return [String]
		def message 
			"#{self.object.errors.first[1]}"
		end
	end
end