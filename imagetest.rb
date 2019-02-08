require 'prawn'
require 'open-uri'

image = 'https://framemark.vam.ac.uk//collections/2006AW1780/full/400,/0/default.jpg'
words = "Hello There"
Prawn::Document.generate "example.pdf" do |pdf|
  pdf.text words
  pdf.image open(image)
end