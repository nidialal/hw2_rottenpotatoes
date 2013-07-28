class Movie < ActiveRecord::Base
	@@possible=['G','PG','PG-13','R']
	def self.create_possible_ratings_array
		return @@possible
	end
end