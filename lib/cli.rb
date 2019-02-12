require_relative 'combineIIIF.rb'

module Console
  def self.start
    puts 'Please enter the url to the IIIF Manifest'
    url= gets.chomp
    # puts "Which page orientation? Press 1 for portrait, or 2 for landscape."
    # choice = gets.chomp.to_i
    layout = "Which page orientation? Press 1 for portrait, or 2 for landscape."
    puts layout
    continue = true
    while continue do
      choice = gets.chomp.to_i
      if choice == 1
        layout_choice = 'portrait'
        continue = false
      elsif choice == 2
        layout_choice = 'landscape'
        continue = false
      else
        puts "Please enter either 1 or 2"
        puts layout
      end
    end
    puts 'enter a numeric value if you want additional padding < 100'
    padding = gets.chomp.to_i
    padding > 100 ? 100 : padding
    puts 'Enter a filename for the pdf'
    filename = gets.chomp
    pdf = ManifestPDF.new(url, layout_choice, padding)
    pdf.save_as("#{filename}.pdf")
    puts "Your pdf called #{filename}.pdf has been created and stored in this directory"
  end
end
