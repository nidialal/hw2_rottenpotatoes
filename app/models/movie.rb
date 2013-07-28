class Movie < ActiveRecord::Base
	@@possible=['G','PG','PG-13','R','NC-17']
	def self.create_possible_ratings_array
		return @@possible
	end
end