# encoding: utf-8

require 'xmlsimple'
require 'set'

class Address	
	def initialize()
		@PATH_OT_DATA_FILE = "resurse/data.xml"
		@selectedCountry = "BY"
		@numberOfResult = 10
		@probabilityOfError = 1
		@SEPARATOR_LOW = " "
		@SEPARATOR_MIDDLE = ", "
		@SEPARATOR_HIGH = "; "
		@RU_ALFABET = (('а'..'я').to_a + ('А'..'Я').to_a).join
		@EN_ALFABET = (('a'..'z').to_a + ('A'..'Z').to_a).join

	end

	def setParameters(selectedCountry, numberOfResult, probabilityOfError)
		@selectedCountry = selectedCountry
		@numberOfResult = numberOfResult
		@probabilityOfError = probabilityOfError	
	end

	def createDataSet()
		data = XmlSimple.xml_in(@PATH_OT_DATA_FILE)	
		loadAbbreviations(data)	
		dataForCountry = getDataForCoutry(data)						
		puts getSetPersonData(dataForCountry)
	end	

	def getSetPersonData(dataForCountry)		
		setData = Set.new
		i = 0
		while i < @numberOfResult
			person = getPersonData(dataForCountry)
			person = createError(person) if isError()			
			setData.add "#{i+1}: " + person	
			i += 1				
		end
		return setData.to_a()
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
		numberOfError = Random.rand(6)
		case numberOfError
		when 0			
			return permutationNumber(string)
		when 1	
			return replaseRandomNamber(string)
		when 2
			return deleteRandomLette(string)
		when 3
			return duplicateLetter(string)
		when 4
			return replaseRandomAdjacentLetters(string)
		when 5
			return addRandomLette(string)
		end											
	end

	def addRandomLette(string)
		positionLetter = getRandomPositionLetter(string)
		randomLetter = getRandomLetter(string, positionLetter)
		string[positionLetter] = randomLetter
		return string
	end

	def getRandomLetter(string, positionLetter)
		randomLetter = ""
		alfabet = []
		if @selectedCountry == "US"
			alfabet = @EN_ALFABET
		elsif @selectedCountry == "BY" or @selectedCountry == "RU"
			alfabet = @RU_ALFABET
		else
			puts @selectedCountry + " not found!"\
		end
		while (randomLetter = alfabet[Random.rand(alfabet.length)]) == string[positionLetter]
		end
		return randomLetter
	end

	def replaseRandomAdjacentLetters(string)
		positionLetters = searchPositionAllLetters(string)
		pairPermutation = generatePairPermutation(positionLetters)
		numberPair = Random.rand(pairPermutation.length)
		first, second = pairPermutation[numberPair][0], pairPermutation[numberPair][1]
		string[first], string[second] = string[second], string[first]
		return string 
	end

	def searchPositionAllLetters(string)
		positionLetters = []		
		i = 0
		for symbol in string.split("")			
			if symbol =~ /[а-яА-Яa-zA-Z]/
				positionLetters.push i				
			end
			i += 1
		end
		return positionLetters
	end

	def duplicateLetter(string)
		positionLetter = getRandomPositionLetter(string)
		return string[0..positionLetter] + string[positionLetter] + string[(positionLetter + 1)..-1]
	end

	def deleteRandomLette(string)
		positionLetter = getRandomPositionLetter(string)
		string[positionLetter] = ""
		return string
	end

	def getRandomPositionLetter(string)		
		positionLetter = []		
		i = 0
		for symbol in string.split("")			
			if symbol =~ /[а-яА-Яa-zA-Z]/
				positionLetter.push i				
			end
			i += 1
		end
		randomPosition = Random.rand(positionLetter.length)
		positionInString = positionLetter[randomPosition]
		return positionInString
	end

	def replaseRandomNamber(string)
		positionNumbers = searchPositionAllNumbers(string)
		randomPosition = Random.rand(positionNumbers.length)
		positionInString = positionNumbers[randomPosition]
		randomNum = 0
		while (randomNum = Random.rand(10)) == string[positionInString].to_i() 
		end
		string[positionInString] = randomNum.to_s()
		return string
	end	

	def permutationNumber(string)
		positionNumbers = searchPositionAllNumbers(string)
		pairPermutation = generatePairPermutation(positionNumbers)
		numberPair = Random.rand(pairPermutation.length)
		first, second = pairPermutation[numberPair][0], pairPermutation[numberPair][1]
		string[first], string[second] = string[second], string[first]
		return string 
	end

	def searchPositionAllNumbers(string)
		positionNumbers = []		
		i = 0
		for symbol in string.split("")			
			if symbol =~ /[0-9]/
				positionNumbers.push i				
			end
			i += 1
		end
		return positionNumbers
	end

	def generatePairPermutation(positionNumbers)
		pairPermutation = []
		i = 0 
		while i < (positionNumbers.length - 1)
			if positionNumbers[i] == (positionNumbers[i+1] - 1)
				pairPermutation.push [positionNumbers[i], positionNumbers[i+1]] 
			end
			i += 1
		end
		return pairPermutation
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

		# puts "!!!!!!-- " + randomCity.to_s + "--!!!!!!!"

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
		code = city['phonecode']		
		phone = ""
		i = 0
		while i < 7 do
			if i == 3
				phone += "-"
			end
			phone += Random.rand(10).to_s()
			i += 1
		end
		return code + "-" + phone			
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
addr.setParameters("RU", 1000 , 0.5)
addr.createDataSet()
