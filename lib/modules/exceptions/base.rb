module Exceptions
	class Base < StandardError
		attr_accessor :object, :type

		# starts a new instance with an object
		# @param [Object] object
		def initialize object
			self.object = object
		end

		# standard error for Models
		# @param [ActiveRecord::Base] object
		# @return [Exceptions::Base]
		def self.build object
			return self.new object
		end

		# return if is as simple error
		# @return [Boolean]
		def simple?
			self.class.name.demodulize.tableize.singularize == "simple"
		end

		# return if is as model error
		# @return [Boolean]
		def model?
			self.class.name.demodulize.tableize.singularize == "model"
		end		

	end
end
