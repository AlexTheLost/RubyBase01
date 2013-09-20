require 'xmlsimple'

# test config:
COUNTRY = "US"
numberOfResult = 10
numberOfResult = 1

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

def getRandomCity(locality)
	randomNumCity = Random.rand(locality.length)
	randomCity = locality[randomNumCity]['name']
	currentXMLBlock = locality[randomNumCity]
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

def getInfoForUS(addr)
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

# def getCountryName(abbreviation)
# 	case abbreviation
# 	when abbreviation == "US" 
# 		return "USA"
# 	when abbreviation == "BY"
# 		return "Беларусь"
# 	when abbreviation == "RU" 
# 		return "SDF"
# 	else 
# 		return "The country is not defined!"
# 	end
# end



data = XmlSimple.xml_in('resurse/data.xml')
countries = data['country']

resultVal = ""
address = {}

# for country in countries
# 	if (countryName = country['name']) == COUNTRY
# 		fullName = getRandomFullName(country['fullnames'])
		

# 		state , currentXMLBlock = getRandomState(country['state'])		
# 		address['state'] = state

# 		city, currentXMLBlock = getRandomCity(currentXMLBlock['city'])
# 		address['city'] = city

# 		phone = getRandomPhone(currentXMLBlock)

# 		street, currentXMLBlock = getRandomStreet(currentXMLBlock['street'])
# 		address['street'] = street

# 		houseNumber, postCode, flatNumber = getRandomHouseAndOther(currentXMLBlock['house'])
# <<<<<<< HEAD
# 		# puts (fullName + "; " + houseNumber + " " + street + ", " + flatNumber + " ," + state + ", " + city + ", " + postCode + ", " + country['name'] + "; " + phone)
# =======
# 		address['houseNumber'] = houseNumber
# 		address['postCode'] = postCode
# 		address['flatNumber'] = flatNumber
# 		address['country'] =  countryName


# 		address = getInfoForUS(address) if countryName == "US"
# 		address = getSNGaddresss(address) if countryName== "BY" || countryName == "RU"


# 		puts (fullName + "; " + address + "; " + phone)
# >>>>>>> 3fe2cb57ff998c27564f6cb4ee0eed995d39ece4
# 	end
# end

class Address
	@selectedCountry = "BY"
	@numberOfResult = 10
	@probabilityOfError = 1
	@abbreviations

	def setParameters(selectedCountry, numberOfResult, probabilityOfError)
		@PATH_OT_DATA_FILE = "resurse/data.xml"
		@selectedCountry = selectedCountry
		@numberOfResult = numberOfResult
		@probabilityOfError = probabilityOfError	

		@SEPARATOR_LOW = " "
		@SEPARATOR_MIDDLE = ", "
		@SEPARATOR_HIGH = "; "
	end

	def iterator()
		getDataSet()

		res = ["a", "b", "c"]
		return Iterator.new(res)
	end

	class Iterator
		@arrayOfString = []
		@index = 0
		@index_max = 0

		def initialize(arrayOfString)
			@arrayOfString = arrayOfString
			@index_max = arrayOfString.length
			@index = 0
		end

		def hasNext()
			if @index >= @index_max
				return false
			else
				return true
			end
		end
		
		def next()
			res = @arrayOfString[@index]	
			@index += 1
			return res	
		end

		def delete()			
		end
	end

	def loadAbbreviations(data)
		@abbreviations = {}
		abbreviations = data['abbreviations'][0]['abbreviation']
		for abbreviation in abbreviations
			@abbreviations[abbreviation['name']] = abbreviation['content']
		end
	end

	def getAbbreviations(word)
		if @abbreviations[word]
			return @abbreviations[word] 
		else
			return word
		end
	end

	def getDataSet()		
		data = XmlSimple.xml_in(@PATH_OT_DATA_FILE)
		loadAbbreviations(data)

		setCountries = data['country']
		dataForCountry = getCoutry(setCountries)

		
		puts person = getLocalizeData(dataForCountry)

	end

	def getLocalizeData(dataForCountry)
		randomFullName = getRandomFullName(dataForCountry)
		randomInfo = getRandomInfo(dataForCountry)
		infoInString = ""
		if @selectedCountry == "US"
			infoInString = getInfoForUS(randomInfo)
		elsif @selectedCountry == "RU" || @selectedCountry == "BY"
			infoInString = getInfoForSNG(randomInfo)
		else
			infoInString = @selectedCountry + " not found!"
		end
		fullName = randomFullName[0] + " " + randomFullName[1]
		res = fullName
		res += @SEPARATOR_HIGH
		res += infoInString
		return res
	end



	def getInfoForUS(info)
		res = info['house'] + @SEPARATOR_LOW + info['street']['name'] + @SEPARATOR_LOW + info['street']['type']
		res += @SEPARATOR_MIDDLE
		res += info['typeOfHousing'] + @SEPARATOR_LOW + info['flatNumber']
		res += @SEPARATOR_MIDDLE
		res += info['state']['name']
		res += @SEPARATOR_MIDDLE
		res += info['locality']['name']
		res += @SEPARATOR_MIDDLE
		res += info['postCode']
		res += @SEPARATOR_MIDDLE
		res += info['country']
		res += @SEPARATOR_HIGH
		res += info['phone']
		return res
	end

	def getInfoForSNG(info)
		res = getAbbreviations(info['street']['type']) + @SEPARATOR_LOW + info['street']['name']
		res += @SEPARATOR_MIDDLE
		res += info['house']
		res += @SEPARATOR_MIDDLE
		res += info['flatNumber']
		res += @SEPARATOR_MIDDLE
		res += getAbbreviations(info['locality']['type']) + @SEPARATOR_LOW + info['locality']['name']
		res += @SEPARATOR_MIDDLE
		res += info['postCode']
		res += @SEPARATOR_MIDDLE
		res += info['country']
		res += @SEPARATOR_HIGH
		res += info['phone']
		return res
	end

	# def toUpperCaseFirstSymbol(str)
	# 	return str[0].upcase() + str[1..-1]
	# end


	def getCoutry(setCountries)
		for country in setCountries
			return country if country['abbreviation'] == @selectedCountry
		end
	end

	def getRandomFullName(dataForCountry)
		setFullName = dataForCountry['fullnames']
		setFirstNames = setFullName[0]['firstname']
		setSecondNames = setFullName[0]['secondname']
		randomNumFirstName = Random.rand(setFirstNames.length)
		randomNumSecondName = Random.rand(setSecondNames.length)
		return [setFirstNames[randomNumFirstName], setSecondNames[randomNumSecondName]]
	end

	def getRandomInfo(dataForCountry)
		location = {}
		location['country'] = dataForCountry['name']
		randomState = getRandomSate(dataForCountry)
		location['state'] = {'type' => randomState['type'], 'name' => randomState['name']}	
		randomCity = getRandomCity(randomState)
		location['locality'] = {'type' => randomCity['type'], 'name' => randomCity['name']}
		location['phone'] = getRandomPhone(randomCity)
		randomStreet = getRandomStreet(randomCity)
		location['street'] = {'type' => randomStreet['type'], 'name' => randomStreet['name']}	
		randomHouse = getRandomHouse(randomStreet)
		location['house'] = randomHouse['number']
		location['postCode'] = randomHouse['postcode']
		location['flatNumber'], location['typeOfHousing'] = getRandomHabitation(randomHouse)
		return location	
	end

	def getRandomSate(country)
		setStates = country['state']
		randomNumState = Random.rand(setStates.length)	
		randomState = setStates[randomNumState]		
	end

	def getRandomCity(state)
		setLocality = state['locality']
		randomNumCity = Random.rand(setLocality.length)		
		randomCity = setLocality[randomNumCity]
	end

	def getRandomPhone(city)
		code = city['phonecode'].gsub!(" ", "-")		
		phone = ""
		i = 0
		while i < 7 do
			if i == 3
				phone += " "
			end
			phone += Random.rand(10).to_s()
			i += 1
		end
		return code + "-" + phone.gsub!(" ", "-")			
	end

	def getRandomStreet(city)		
		setStreests = city['street']
		randomNumStreet = Random.rand(setStreests.length)	
		randomStreet = setStreests[randomNumStreet]
	end

	def getRandomHouse(street)
		setHouses = street['house']
		randomNumHouse = Random.rand(setHouses.length)
		randomHouse = setHouses[randomNumHouse]
	end

	def getRandomHabitation(house)
		setHabitation = house['habitationnumber']
		randomNumHabitation = Random.rand(setHabitation.length)
		randomHabitation = setHabitation[randomNumHabitation]
		firstNumberFlat = randomHabitation['firstnumber'].to_i()
		lastNumberFlat = randomHabitation['lastnumber'].to_i()	
		flatNumber = Random.rand(firstNumberFlat...lastNumberFlat).to_s()
		typeOfHousing = randomHabitation['prefix']	
		return [flatNumber, typeOfHousing]
	end

end

addr = Address.new()
addr.setParameters("RU", 10 , 1)
iter = addr.iterator()

# while iter.hasNext()
# 	puts iter.next()
# end	
