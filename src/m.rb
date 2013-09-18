# coding: utf-8

def firstArg(arg)
	if (/^US$|^RU$|^BY$/i.match arg)==nil
		puts "#{arg} incorrect"
		puts "first arg: US|RU|BY"
		exit
	end
end

def secondArg(arg)
	if (/^[0-9]+$/.match arg)==nil
		puts "#{arg} incorrect"
		puts "second arg: 1..1000000"
		exit
	elsif Integer(arg) < 1 || Integer(arg) > 1000000
		puts "second arg: 1..1000000"
	end
end

def thirdArg(arg)
	if (/^[0].?[0-9]*$|^[1]$/.match arg)==nil
		puts "third arg: [0;1]"
	end
end

if __FILE__ == $0

	if ARGV.length != 3
		puts "Error: argv != 3"
		exit
	end

	firstArg(ARGV[0])
	secondArg(ARGV[1])
	thirdArg(ARGV[2])

end