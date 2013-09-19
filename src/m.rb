require 'xmlsimple'

data = XmlSimple.xml_in('resurse/data.xml')
countries = data['country']

puts countries
#, {'KeyAttr' => 'name'}

# puts config['country']['US']['fullnames'][0]['secondName']

# countryNumber = data['country'].length
# country = Random.rand(countryNumber)

# for


# puts data['country'][country]