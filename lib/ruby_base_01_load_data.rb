# encoding: utf-8
require 'xmlsimple'

class RubyBase01ReadData
    public

    def initialize()
        @PATH_OT_DATA_FILE = "resurse/data.xml"
    end

    def get_data(abbreviation)
        data = XmlSimple.xml_in(@PATH_OT_DATA_FILE)
        country = select_country(data, abbreviation)
        get_data_by_country(country)
    end

    private

    def get_data_by_country(country)
    	template_country = [country['name']]
    	states = country['state']
    	data_by_state = get_data_by_states(template_country, states)

    	save_to_file('resurse/out.txt', data_by_state)
    end

    def select_country(data, abbreviation)
    	country = data['country']
    	for data_by_country in country
    		if data_by_country['abbreviation'] == abbreviation
    			return data_by_country
    		end
    	end
    end

    def get_data_by_states(template_country, states)
    	result = []
    	for state in states
    		template_state = template_country.dup
    		template_state.push state['type']
    		template_state.push state['name']
    		result += get_data_by_state(template_state, state)
    	end
    	return result
    end

    def get_data_by_state(template_state, state)
    	result = []
    	localities = state['locality']
    	for locality in localities
    		template_locality = template_state.dup
    		template_locality.push locality['type']
    		template_locality.push locality['name']
    		result += get_data_by_locality(template_locality, locality)
    	end
    	return result
    end

    def get_data_by_locality(template_locality, locality)
    	result = []
    	streets = locality['street']
    	for street in streets
    		template_street = template_locality.dup
    		template_street.push street['type']
    		template_street.push street['name']
    		result += get_data_by_streets(template_street, street)
    	end
    	return result
    end

    def get_data_by_streets(template_street, street)
    	result = []
    	houses = street['house']
    	for house in houses
    		template_house = template_street.dup
    		template_house.push house['number']
    		template_house.push house['postcode']
    		result += get_data_by_house(template_house, house)
    	end    	
    	return result
    end

    def get_data_by_house(template_house, house)
    	result = []
    	habitations = house['habitation']
    	for habitation in habitations
    		template_habitation = template_house.dup
    		template_habitation.push habitation['prefix']
    		result += get_data_by_habitation_numbers(template_habitation, habitation)
    	end
    	return result
    end

    def get_data_by_habitation_numbers(template_habitation, habitation)
    	firstnumber = habitation['firstnumber'].to_i()
    	lastnumber = habitation['lastnumber'].to_i()
    	result = []
    	for i in firstnumber..lastnumber
    		template_habitation_numbers = template_habitation.dup
    		template_habitation_numbers.push i.to_s
    		result.push template_habitation_numbers
    	end   	
    	return result
    end

    def pt(arr)
    	for el in arr
    		puts el.join('|')
    	end
    end

    def save_to_file(f_name, data)
    	text = "length: #{data.length} \n"
    	for line in data
    		text += "\n#{line.join('/')}"
    	end
    	File.open(f_name, 'w') { |file| file.write(text) }
    	puts "save to #{f_name} execute"
    end

end

RubyBase01ReadData.new().get_data("US")
