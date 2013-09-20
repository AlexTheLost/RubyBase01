require 'xmlsimple'

class Address	
	def initialize()
		@PATH_OT_DATA_FILE = "resurse/data.xml"
		@selectedCountry = "BY"
		@numberOfResult = 10
		@probabilityOfError = 1
		@SEPARATOR_LOW = " "
		@SEPARATOR_MIDDLE = ", "
		@SEPARATOR_HIGH = "; "
	end

	def setParameters(selectedCountry, numberOfResult, probabilityOfError)
		@selectedCountry = selectedCountry
		@numberOfResult = numberOfResult
		@probabilityOfError = probabilityOfError	
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

	def getDataSet()
		data = XmlSimple.xml_in(@PATH_OT_DATA_FILE)	
		loadAbbreviations(data)	
		dataForCountry = getDataForCoutry(data)						
		puts person = getPersonData(dataForCountry)
		if isError()
			person = createError(person)
			puts "Create Error!:"
		end
		return person
	end	

	def isError()
		probabilityOfError = (@probabilityOfError * 100).ceil()
		if Random.rand(100) <= probabilityOfError
			return true
		else
			return false
		end
	end

	def createError(string)
		# numberOfError = Random.rand(6)
		numberOfError = 0
		case numberOfError
		when 0
			puts "Error 1"
			return permutationNumber(string)
		when 1
			puts "Error 2"			
		when 2
			puts "Error 3"
		when 3
			puts "Error 4"
		when 4
			puts "Error 5"
		when 5
			puts "Error 6"	
		end											
	end

	def permutationNumber(string)
		position = []		
		i = 0
		for symbol in string.split("")			
			if symbol =~ /[0-9]/
				position.push i				
			end
			i += 1
		end
		puts position.join('/')
		# i = 1
		# while i < position.length

		final = []
		i = 0 
		while i < (position.length - 1)
			if position[i] == (position[i+1] - 1)
				final.push [position[i], position[i+1]] 
			end
			i += 1
		end
		puts final.join('|')	
	end

	def loadAbbreviations(data)
		@abbreviations = {}
		abbreviations = data['abbreviations'][0]['abbreviation']
		for abbreviation in abbreviations
			@abbreviations[abbreviation['name']] = abbreviation['content']
		end
	end	

	def getDataForCoutry(data)
		setCountries = data['country']
		for country in setCountries
			return country if country['abbreviation'] == @selectedCountry
		end
	end

	def getPersonData(dataForCountry)		
		randomFullName = getRandomFullName(dataForCountry)
		randomInfo = getRandomInfo(dataForCountry)	
		personData = getLocalizeData(randomFullName, randomInfo)
		return personData
	end

	def getRandomFullName(dataForCountry)
		setFullName = dataForCountry['fullnames']
		setFirstNames = setFullName[0]['firstname']
		setSecondNames = setFullName[0]['secondname']
		randomNumFirstName = Random.rand(setFirstNames.length)
		randomNumSecondName = Random.rand(setSecondNames.length)
		return {'firstname' => setFirstNames[randomNumFirstName], 'secondname' => setSecondNames[randomNumSecondName]}
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

	def getLocalizeData(fullName, info)
		if @selectedCountry == "US"
			localizeFullName = fullName['firstname'] + " " + fullName['secondname']
			localizeInfo = getInfoForUS(info)
		elsif @selectedCountry == "RU" || @selectedCountry == "BY"
			localizeFullName = fullName['secondname'] + " " + fullName['firstname']
			localizeInfo = getInfoForSNG(info)
		else
			return @selectedCountry + " not found!"
		end		
		return localizeFullName + @SEPARATOR_HIGH + localizeInfo
	end	

	def getInfoForUS(info)
		res = info['house'] + @SEPARATOR_LOW + info['street']['name'] + @SEPARATOR_LOW + toUpperCaseFirstSymbol(info['street']['type'])
		res += @SEPARATOR_MIDDLE
		res += toUpperCaseFirstSymbol(info['typeOfHousing']) + @SEPARATOR_LOW + info['flatNumber']
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

	def toUpperCaseFirstSymbol(str)
		return str[0].upcase() + str[1..-1]
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

	def getAbbreviations(word)
		if @abbreviations[word]
			return @abbreviations[word] 
		else
			return word
		end
	end
end

addr = Address.new()
addr.setParameters("BY", 10 , 1)
addr.iterator()
# addr.setParameters("US", 10 , 1)
# addr.iterator()
# addr.setParameters("RU", 10 , 1)
# iter = addr.iterator()

# while iter.hasNext()
# 	puts iter.next()
# end	
