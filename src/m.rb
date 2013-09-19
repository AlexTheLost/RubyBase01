require 'rexml/document'

file = IO.read("data.xml")
doc = REXML::Document.new file
puts doc.to_s
