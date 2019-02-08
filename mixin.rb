# This uses the prawn mixin
require 'prawn'
require 'httparty'
require 'open-uri'

class ManifestPDF

  include Prawn::View

  attr_accessor :url, :response, :manifest, :name

  def initialize(name)
    @name = name
    @url = 'https://iiif.vam.ac.uk/collections/MSL:1876:Forster:141:I/manifest.json'
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
      self.text item['label']['@none'][0]
      item['items'].each do |item_depth2|
        item_depth2['items'].each do |item_depth3|
          image_url = item_depth3['body']['id']
          resize_image_url = image_url.gsub(/full\/full/, "full/300,")
          self.image open(resize_image_url)
        end
      end
      footer
    end
  end

  def footer
    self.text '==============='
    self.text 'From the V&A'
  end

end

test = ManifestPDF.new('test')
test.iterate
test.save_as('self.pdf')
