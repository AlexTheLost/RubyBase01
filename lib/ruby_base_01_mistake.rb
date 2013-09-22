# encoding: utf-8

class RubyBase01Mistake
    public

    def initialize()
        @US = "US"
        @RU = "RU"
        @BY = "BY"
        @RU_ALFABET_UPPERCASE = ('А'..'Я').to_a().join()
        @EN_ALFABET_UPPERCASE = ('A'..'Z').to_a().join()
        @RU_ALFABET_LOWERCASE = ('а'..'я').to_a().join()
        @EN_ALFABET_LOWERCASE = ('a'..'z').to_a().join()
    end

    def create_mistake(string, probability_of_mistake, country)
        @country = country
        mistake = if_mistake(probability_of_mistake)
        if mistake then add_random_type_of_mistake(string) else string end
    end

    private

    def if_mistake(probability_of_mistake)
        probability_of_mistake = (probability_of_mistake * 100).ceil()
        if Random.rand(100) <= probability_of_mistake then true else false end
    end

    def add_random_type_of_mistake(string)
        number_of_mistake = Random.rand(6)
        case number_of_mistake
        when 0
            return permutation_adjacent_numbers(string)
        when 1
            return mutate_number(string)
        when 2
            return delete_lette(string)
        when 3
            return duplicate_letter(string)
        when 4
            return permutation_adjacent_letters(string)
        when 5
            return mutate_letter(string)
        end
    end

    def permutation_adjacent_numbers(string)
        position_of_numbers = search_position_all_numbers(string)
        pairs_permutation = generate_pairs_permutation(position_of_numbers)
        return swapping_lette(string, pairs_permutation)
    end

    def search_position_all_numbers(string)
        position_of_numbers = []
        i = 0
        for symbol in string.split("")
            if symbol =~ /[0-9]/
                position_of_numbers.push i
            end
            i += 1
        end
        return position_of_numbers
    end

    def generate_pairs_permutation(position_of_numbers)
        pairs_permutation = []
        i = 0 
        while i < (position_of_numbers.length - 1)
            if position_of_numbers[i] == (position_of_numbers[i+1] - 1)
                pairs_permutation.push [position_of_numbers[i], position_of_numbers[i+1]]
            end
            i += 1
        end
        return pairs_permutation
    end

    def swapping_lette(string, pairs_permutation)
        number_of_pair = Random.rand(pairs_permutation.length)
        first_number = pairs_permutation[number_of_pair][0]
        second_number = pairs_permutation[number_of_pair][1]
        string[first_number], string[second_number] = string[second_number], string[first_number]
        return string
    end

    def mutate_number(string)
        position_of_numbers = search_position_all_numbers(string)
        random_position = Random.rand(position_of_numbers.length)
        position_in_string = position_of_numbers[random_position]
        new_number =  get_new_number(string, position_in_string)
        string[position_in_string] = new_number.to_s()
        return string
    end

    def get_new_number(string, position_in_string)
        random_number = 0
        while (random_number = Random.rand(10)) == string[position_in_string].to_i() do end
        return random_number
    end

    def delete_lette(string)
        position_letter = get_random_position_of_letter(string)
        string[position_letter] = ""
        return string
    end

    def duplicate_letter(string)
        position_letter = get_random_position_of_letter(string)
        return string[0..position_letter] + string[position_letter] + string[(position_letter + 1)..-1]
    end

    def get_random_position_of_letter(string)
        position_letter = []
        i = 0
        for symbol in string.split("")
            if symbol =~ /[а-яА-Яa-zA-Z]/
                position_letter.push i
            end
            i += 1
        end
        random_position = Random.rand(position_letter.length)
        position_in_string = position_letter[random_position]
        return position_in_string
    end

    def permutation_adjacent_letters(string)
        position_of_letters = search_position_all_letters(string)
        pairs_permutation = generate_pairs_permutation(position_of_letters)
        return swapping_lette(string, pairs_permutation)
    end

    def search_position_all_letters(string)
        position_letters = []
        i = 0
        for symbol in string.split("")
            if symbol =~ /[а-яА-Яa-zA-Z]/
                position_letters.push i
            end
            i += 1
        end
        return position_letters
    end

    def mutate_letter(string)
        position_letter = get_random_position_of_letter(string)
        random_letter = get_random_letter(string, position_letter)
        string[position_letter] = random_letter
        return string
    end

    def get_random_letter(string, position_letter)
        current_letter = string[position_letter]
        alfabet = get_alfabet(current_letter)
        random_letter = ""
        while (random_letter = alfabet[Random.rand(alfabet.length)]) == current_letter do end
        return random_letter
    end

    def get_alfabet(letter)
        lowercase = if_lowercase(letter)
        if @country == @US
            if lowercase then return @EN_ALFABET_LOWERCASE else return @EN_ALFABET_UPPERCASE end
        elsif @country == @BY or @country == @RU
            if lowercase then return @RU_ALFABET_LOWERCASE else return @RU_ALFABET_UPPERCASE end
        end
    end

    def if_lowercase(letter)
        if letter =~ /[a-zа-я]/ then true else false end
    end
end