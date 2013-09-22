# считать все данные в массив, каждый уникальный адрес представить массивом или хешем
# передать массив данных на обработку, где будут отобраны n случайных и дополнены информацией
# => выбираем слуйчайны номер из исходного массива данных, 
# =>    помещаем его в результирующий массив и удаляем его из исходного

require 'xmlsimple'

class RubyBase01ReadData
    public

    def initialize()
        @PATH_OT_DATA_FILE = "resurse/data.xml"
    end

    def get_data(country)
        @country = country
        @data = XmlSimple.xml_in(@PATH_OT_DATA_FILE)
    end

    private
end

RubyBase01ReadData.new().get_data("BY")
