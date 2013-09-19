require 'xmlsimple'

# config:
COUNTRY = "RU"
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
	return [stateName, currentXMLBlock]
end

def getRandomCity(cities)
	randomNumCity = Random.rand(cities.length)
	randomCity = cities[randomNumCity]['name']
	currentXMLBlock = cities[randomNumCity]
	return [randomCity, currentXMLBlock]	
end

# puts config['country']['US']['fullnames'][0]['secondName']
#, {'KeyAttr' => 'name'}

data = XmlSimple.xml_in('resurse/data.xml')
countries = data['country']

currentXMLBlock = {}

for country in countries
	if country['name'] == COUNTRY
		fullName = getRandomFullName(country['fullnames'])
		puts fullName		

		state , currentXMLBlock = getRandomState(country['state'])
		puts state

		city, currentXMLBlock = getRandomCity(currentXMLBlock['city'])
		puts city
		
		# puts fullName
		# puts information
	end
end

