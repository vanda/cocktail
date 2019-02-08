# This prints through images
require 'prawn'
require 'httparty'

class ManifestPDF
  # include Prawn::View

  attr_accessor :url, :response, :manifest

  def initialize(url)
    @url = url
    @response = scrape
    @manifest = parse
  end

  def scrape
    HTTParty.get(@url)
  end

  def parse
    JSON.parse(@response.body)
  end

  def iterate
    @manifest['items'].each do |item|
      puts item['label']['@none']
      item['items'].each do |item_depth2|
        item_depth2['items'].each do |item_depth3|
          puts item_depth3['body']['id']
        end
      end
      footer
    end
  end

  def footer
    puts '==============='
    puts 'From the V&A'
  end

end

test = ManifestPDF.new('https://iiif.vam.ac.uk/collections/MSL:1876:Forster:141:I/manifest.json')
test.iterate
