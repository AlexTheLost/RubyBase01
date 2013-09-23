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
    	get_data_by_states(template_country, states)
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
    	for state in states
    		template_state = template_country.dup
    		template_state.push state['name']
    		get_data_by_state(template_state, state)
    	end
    end

    def get_data_by_state(template_state, state)
    	localities = state['locality']
    	for locality in localities
    		template_locality = template_state.dup
    		template_locality.push locality['name']
    		get_data_by_locality(template_locality, locality)
    	end
    end

    def get_data_by_locality(template_locality, locality)
    	streets = locality['street']
    	for street in streets
    		template_street = template_locality.dup
    		template_street.push street['name']
    		get_data_by_streets(template_street, street)
    	end
    end

    def get_data_by_streets(template_street, street)
    	houses = street['house']
    	for house in houses
    		template_house = template_street.dup
    		template_house.push house['number']
    		template_house.push house['postcode']
    		get_data_by_house(template_house, house)
    	end
    end

    def get_data_by_house(template_house, house)
    	# pt(template_house)
    	habitations = house['habitation']
    	for habitation in habitations
    		template_habitation = template_house.dup
    		template_habitation.push habitation['prefix']
    		get_data_by_habitation_numbers(template_habitation, habitation)
    	end

    end

    def get_data_by_habitation_numbers(template_habitation, habitation)
    	pt(template_habitation)
    end

    def pt(template)
    	puts template.join('/')
    end

end

RubyBase01ReadData.new().get_data("US")
