require 'optparse'
require 'pp'
require_relative 'extract_IIIF.rb'

ARGV << '-h' if ARGV.empty?

class OptionParser
  def self.parse(args)
    options = OpenStruct.new
    options.url = ''
    options.layout = 'portrait'
    options.padding = 10
    options.filename = 'manifest'
    options.title = false
    options.prefix = false
    options.title_path = './images/title.jpg'
    options.font_size = 14
    options.padding_color = '000000'
    options.footer_content = 'Victoria and Albert Museum, London'
    options.custom_font_path = './font/vanda5.ttf'

    opt_parser = OptionParser.new do |opts|
      opts.banner = 'Usage: options.rb [options]'

      opts.separator ''
      opts.separator 'Specific options:'

      # Boolean switch for folio prefix.
      opts.on('-a', '--[no-]prefix', 'Add ff. prefix') do |a|
        options.prefix = a
      end

      opts.on('-b', '--footer_content CONTENT', 'Enter organisation description for left footer copyright notice.') do |b|
        options.footer_content = b
      end

      opts.on('-c', '--fill_color FILLCOLOR', 'Enter padding colour in hex, default is black.') do |c|
        options.padding_color = c
      end

      opts.on('-d', '--font_path FONTPATH', 'The url/path to the custom ttf') do |d|
        options.custom_font_path = d
      end

      opts.on('-f', '--filename FILENAME', 'Enter filename for pdf, default is manifest.') do |f|
        options.filename = f
      end

      opts.on('-h', '--help', 'Displays help') do
        puts opts
        exit
      end

      opts.on('-i', '--title_image_path IMAGEPATH', 'The url/path to the title image') do |i|
        options.i = i
      end

      opts.on('-l [LAYOUT]', [:portrait, :landscape],
        'Select layout type (portrait, landscape)') do |l|
        options.layout = l
      end

      opts.on('-p', '--padding PADDING', OptionParser::DecimalInteger, 'Enter padding value, default is 10.') do |p|
        options.padding = p
      end

      opts.on('-s', '--font_size FONTSIZE', OptionParser::DecimalInteger, 'Enter font size, default is 14.') do |s|
        options.font_size = s
      end

      # Boolean switch for title page.
      opts.on('-t', '--[no-]title', 'Add title page') do |t|
        options.title = t
      end

      # Mandatory argument
      opts.on('-u', '--url REQUIRED URL', 'The url to the IIIF Manifest') do |url|
        options.url << url
      end
    end

    opt_parser.parse!(args)
    options
  end
end

options = OptionParser.parse(ARGV)
puts 'Preparing your pdf with the following options:'
pp options

pdf = Cocktail.new(options.url, options.layout, options.padding,
                   options.font_size, options.padding_color,
                   options.prefix, options.footer_content,
                   options.custom_font_path)
if options.title then pdf.insert_title(options.title_path) end
pdf.manifest_extract
pdf.page_generation
pdf.save_as("#{options.filename}.pdf")
puts "Your #{options.filename}.pdf should be available in the root of this project"
