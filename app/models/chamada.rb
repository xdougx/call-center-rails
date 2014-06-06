class Chamada < ActiveRecord::Base
	belongs_to :funcionario
	belongs_to :central

	scope :aguardando, -> { where(status: 'aguardando') } 


end
