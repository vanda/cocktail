require 'prawn'
require 'httparty'

class ManifestPDF < Prawn::Document

  attr_accessor :url, :response, :manifest

  def initialize(url = 'https://iiif.vam.ac.uk/collections/MSL:1876:Forster:141:I/manifest.json')
    @url = url
    @response = scrape
    @manifest = parse
  end

  def scrape
    HTTParty.get(@url)
  end

  def display
    puts @manifest
  end

  def parse
    JSON.parse(@response.body)
  end

  def iterate
    @manifest['items'].each do |item|
      text item['label']['@none']
      item['items'].each do |item_depth2|
        item_depth2['items'].each do |item_depth3|
          text item_depth3['id']
        end
      end
    end
  end

  def footer
    text '==============='
    text 'From the V&A'
  end

end

test = ManifestPDF.new('https://iiif.vam.ac.uk/collections/MSL:1876:Forster:141:I/manifest.json')
test.footer
