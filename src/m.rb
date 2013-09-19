require 'xmlsimple'

# config:
COUNTRY = "US"
NUMBER_OF_RESULT = 10
PROBABYLITY_OF_ERROR = 1

def getRandomFullName(fullNames)
	firstNames = fullNames[0]['firstname']
	secondNames = fullNames[0]['secondname']
	randomNumFirstName = Random.rand(firstNames.length)
	randomNumSecondName = Random.rand(secondNames.length)
	return firstNames[randomNumFirstName] + " " + secondNames[randomNumSecondName]
end

def getRandomInformation(location)
	return location
end

# puts config['country']['US']['fullnames'][0]['secondName']
#, {'KeyAttr' => 'name'}
data = XmlSimple.xml_in('resurse/data.xml')
countries = data['country']

for country in countries
	if country['name'] == COUNTRY
		fullName = getRandomFullName(country['fullnames'])
		information = getRandomInformation(country['staff'])
		
		puts fullName
		# puts information
	end
end

