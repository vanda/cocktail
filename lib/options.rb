require 'optparse'
require 'pp'
require_relative 'combineIIIF.rb'

class OptionParser
  def self.parse(args)
    options = OpenStruct.new
    options.url = ''
    options.layout = 'portrait'
    options.padding = 10
    options.filename = 'manifest'
    options.title = false
    options.title_path = './images/title.jpg'
    options.font_size = 14

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: options.rb [options]"

      opts.separator ""
      opts.separator "Specific options:"

      # Mandatory argument
      opts.on('-u', '--url URL', 'The url to the IIIF Manifest') do |url|
        options.url << url
      end

      opts.on('-tp', '--titlepath', 'The url/path to the title image') do |tp|
        options.tp = tp
      end

      # Boolean switch.
      opts.on("-t", "--[no-]title", "Add title page") do |t|
        options.title = t
      end

      opts.on("-l [LAYOUT]", [:portrait, :landscape],
        "Select layout type (portrait, landscape)") do |l|
        options.layout = l
      end

      opts.on('-p', '--padding PADDING', OptionParser::DecimalInteger, 'Enter padding value, default is 10.') do |p|
        options.padding = p
      end

      opts.on('-s', '--font_size FONTSIZE', OptionParser::DecimalInteger, 'Enter font size, default is 14.') do |s|
        options.font_size = s
      end

      opts.on('-f', '--filename FILENAME', 'Enter filename for pdf, default is manifest.') do |f|
        options.filename = f
      end

      opts.on('-h', '--help', 'Displays help') do
        puts opts
        exit
      end

    end

    opt_parser.parse!(args)
    options
  end
end
# args = OptionParser.parse %w[--help]

options = OptionParser.parse(ARGV)
pp options
pp ARGV

pdf = ManifestPDF.new(options.url, options.layout, options.padding, options.font_size)
if options.title then pdf.insert_title(options.title_path) end
pdf.iterate
pdf.save_as("#{options.filename}.pdf")
