# encoding: utf-8

# ruby_base_01_mistake.rb.rb  
require_relative 'ruby_base_01_mistake.rb'

# ruby_base_01_load_data.rb.rb  
require_relative 'ruby_base_01_load_data.rb'

# m = RubyBase01Mistake.new()
# puts m.create_mistake("ABS 123", 1, "US")
# d = RubyBase01ReadData.new()

class RubyBase01GenerationData
	def get_data(abbr, size, prob)
		@abbreviation = abbr
		@size = size
		@prob = prob

		data = RubyBase01LoadData.new().get_data("US")

		sample_data = select_random_data(data)
		puts sample_data
	end

	def select_random_data(data)
		return data.sample(@size)		
	end
end

RubyBase01GenerationData.new().get_data("US", 100, 1)

