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
	if stateName == "NONE"
		stateName = ""
	end	
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
	randomStreet = streets[randomNumStreet]['name'] + " " + streets[randomNumStreet]['type']
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
	flatNumber = typeOfHousing + " " + flatNumber.to_s()

	return [randomHouse, postCode, flatNumber]
end


data = XmlSimple.xml_in('resurse/data.xml')
countries = data['country']


for country in countries
	if country['name'] == COUNTRY
		fullName = getRandomFullName(country['fullnames'])	
		state , currentXMLBlock = getRandomState(country['state'])
		city, currentXMLBlock = getRandomCity(currentXMLBlock['city'])
		phone = getRandomPhone(currentXMLBlock)
		street, currentXMLBlock = getRandomStreet(currentXMLBlock['street'])
		houseNumber, postCode, flatNumber = getRandomHouseAndOther(currentXMLBlock['house'])
		puts (fullName + "; " + houseNumber + " " + street + ", " + flatNumber + " ," + state + ", " + city + ", " + postCode + ", " + country['name'] + "; " + phone)
	end
end

