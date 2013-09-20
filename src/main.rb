require 'xmlsimple'

# test config:
COUNTRY = "BY"
NUMBER_OF_RESULT = 10
PROBABYLITY_OF_ERROR = 1

def getRandomFullName(fullNames)
	firstNames = fullNames[0]['firstname']
	secondNames = fullNames[0]['secondname']
	randomNumFirstName = Random.rand(firstNames.length)
	randomNumSecondName = Random.rand(secondNames.length)
	return firstNames[randomNumFirstName] + " " + secondNames[randomNumSecondName]
end

def getRandomState(states)
	randomNumState = Random.rand(states.length)	
	stateName = states[randomNumState]['name']	
	currentXMLBlock = states[randomNumState]
	return stateName, currentXMLBlock
end

def getRandomCity(cities)
	randomNumCity = Random.rand(cities.length)
	randomCity = cities[randomNumCity]['name']
	currentXMLBlock = cities[randomNumCity]
	return randomCity, currentXMLBlock	
end

def getRandomPhone(city)	
	phoneCode = city['phonecode']
	randomPhone = ""
	i = 0
	while i < 7 do
		if i == 3
			randomPhone += " "
		end
		randomPhone += Random.rand(10).to_s()
		i += 1
	end

	return (phoneCode + " " + randomPhone).gsub!(" ", "-")
end

def getRandomStreet(streets)
	randomNumStreet = Random.rand(streets.length)	
	randomStreet = [streets[randomNumStreet]['name'], streets[randomNumStreet]['type']]
	currentXMLBlock = streets[randomNumStreet]
	return randomStreet, currentXMLBlock
end

def getRandomHouseAndOther(houses)
	randomNumHouse = Random.rand(houses.length)
	randomHouse = houses[randomNumHouse]['number']
	postCode = houses[randomNumHouse]['postcode']
	
	randomNumFlat = Random.rand(houses[randomNumHouse]['habitationnumber'].length)
	randomFlat = houses[randomNumHouse]['habitationnumber'][randomNumFlat]
	firstNumberFlat = randomFlat['firstnumber'].to_i()
	lastNumberFlat = randomFlat['lastnumber'].to_i()
	flatNumber = Random.rand(firstNumberFlat...lastNumberFlat)

	typeOfHousing = randomFlat['prefix']
	flatNumber = [typeOfHousing, flatNumber.to_s()]

	return [randomHouse, postCode, flatNumber]
end

def getUSaddresss(addr)
	res = addr['houseNumber'] + ", "
	res += addr['street'] + ", "
	res += addr['flatNumber'] + ", "
	res += addr['state'] + ", "
	res += addr['city'] + ", "
	res += addr['postCode'] + ", "
	res += addr ['country']
	return res
end

def getSNGaddresss(addr)
	res = addr['street'][1] + " " + addr['street'][0] + ", "
	res += addr['houseNumber'] + ", "
	res += addr['flatNumber'][1] + ", "
	res += addr['city'] + ", "
	# res += addr['state'] + ", "
	res += addr['postCode'] + ", "
	res += addr ['country']
	return res
end

def getCountryName(abbreviation)
	case abbreviation
	when abbreviation == "US" 
		return "USA"
	when abbreviation == "BY"
		return "Беларусь"
	when abbreviation == "RU" 
		return "SDF"
	else 
		return "The country is not defined!"
	end
end



data = XmlSimple.xml_in('resurse/data.xml')
countries = data['country']

resultVal = ""
address = {}

for country in countries
	if (countryName = country['name']) == COUNTRY
		fullName = getRandomFullName(country['fullnames'])
		

		state , currentXMLBlock = getRandomState(country['state'])		
		address['state'] = state

		city, currentXMLBlock = getRandomCity(currentXMLBlock['city'])
		address['city'] = city

		phone = getRandomPhone(currentXMLBlock)

		street, currentXMLBlock = getRandomStreet(currentXMLBlock['street'])
		address['street'] = street

		houseNumber, postCode, flatNumber = getRandomHouseAndOther(currentXMLBlock['house'])
		address['houseNumber'] = houseNumber
		address['postCode'] = postCode
		address['flatNumber'] = flatNumber
		address['country'] =  countryName


		address = getUSaddresss(address) if countryName == "US"
		address = getSNGaddresss(address) if countryName== "BY" || countryName == "RU"


		puts (fullName + "; " + address + "; " + phone)
	end
end
