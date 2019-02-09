# This uses the prawn mixin
require 'prawn'
require 'httparty'
require 'open-uri'

class ManifestPDF

  include Prawn::View

  attr_accessor :url, :response, :manifest, :width

  def initialize(url, width = 500)
    @url = url
    @response = scrape
    @manifest = parse
    @width = width
  end

  def iterate
    @manifest['items'].each do |item|
      item['items'].each do |item_depth2|
        item_depth2['items'].each do |item_depth3|
          image_url = item_depth3['body']['id']
          resize_image_url = image_url.gsub(/[^\/]*\/[^\/]*\/0/, "full/#{width},/0,")
          self.image open(resize_image_url)
        end
      end
      self.move_down 15
      self.text item['label']['@none'][0]
      footer
    end 
  end

  def footer
    self.text '==============='
    self.text 'From the V&A'
  end

  private

  def scrape
    HTTParty.get(@url)
  end

  def parse
    JSON.parse(@response.body)
  end

end

test = ManifestPDF.new('https://iiif.vam.ac.uk/collections/MSL:1876:Forster:141:I/manifest.json', 440)
test.iterate
test.save_as('self.pdf')
