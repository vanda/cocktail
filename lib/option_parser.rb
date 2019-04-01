require 'optparse'
require 'pp'
require_relative 'extract_IIIF.rb'

ARGV << '-h' if ARGV.empty?

class OptionParser
  def self.parse(args)
    options = {
      url: '',
      layout: 'portrait',
      padding: 10,
      filename: 'manifest',
      title: false,
      prefix: false,
      title_path: './images/title.jpg',
      font_size: 14,
      padding_color: '000000',
      footer_content: 'Victoria and Albert Museum, London',
      custom_font_path: './font/vanda5.ttf',
      canvas_start: nil,
      canvas_length: nil
    }

    opt_parser = OptionParser.new do |opts|
      opts.banner = 'Usage: options.rb [options]'
      opts.separator ''
      opts.separator 'Specific options:'

      # Boolean switch for folio prefix.
      opts.on('-a', '--[no-]prefix', 'Add ff. prefix') do |a|
        options[:prefix] = a
      end

      opts.on('-b', '--footer_content CONTENT', 'Enter organisation description for left footer copyright notice.') do |b|
        options[:footer_content] = b
      end

      opts.on('-c', '--fill_color FILLCOLOR', 'Enter padding colour in hex, default is black.') do |c|
        options[:padding_color] = c
      end

      opts.on('-d', '--font_path FONTPATH', 'The url/path to the custom ttf') do |d|
        options[:custom_font_path] = d
      end

      opts.on('-f', '--filename FILENAME', 'Enter filename for pdf, default is manifest.') do |f|
        options[:filename] = f
      end

      opts.on('-h', '--help', 'Displays help') do
        puts opts
        exit
      end

      opts.on('-i', '--title_image_path IMAGEPATH', 'The url/path to the title image') do |i|
        options[:title_image_path] = i
      end

      opts.on('-j', '--array_start START', OptionParser::DecimalInteger, 'If printing only a range of images, enter start value (0 index).') do |j|
        options[:canvas_start] = j
      end

      opts.on('-k', '--array_length LENGTH', OptionParser::DecimalInteger, 'If printing only a range of images, enter length.') do |k|
        options[:canvas_length] = k
      end

      opts.on('-l [LAYOUT]', %i[portrait landscape],
              'Select layout type (portrait, landscape)') do |l|
        options[:layout] = l
      end

      opts.on('-p', '--padding PADDING', OptionParser::DecimalInteger, 'Enter padding value, default is 10.') do |p|
        options[:padding] = p
      end

      opts.on('-s', '--font_size FONTSIZE', OptionParser::DecimalInteger, 'Enter font size, default is 14.') do |s|
        options[:font_size] = s
      end

      # Boolean switch for title page.
      opts.on('-t', '--[no-]title', 'Add title page') do |t|
        options[:title] = t
      end

      # Mandatory argument
      opts.on('-u', '--url REQUIRED URL', 'The url to the IIIF Manifest') do |url|
        options[:url] << url
      end

      opts.on('-v', '--configfile PATH', String, 'Set config file') do |path|
        options.merge!(Hash[YAML.safe_load(open(path)).map { |k, v| [k.to_sym, v] }])
      end
    end

    opt_parser.parse!(args)
    options
  end
end
