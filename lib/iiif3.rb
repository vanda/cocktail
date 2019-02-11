# This uses the prawn mixin
require 'prawn'
require 'httparty'
require 'open-uri'

class ManifestPDF_V3

  include Prawn::View

  attr_accessor :url, :response, :manifest

  def initialize(url)
    @url = url
    @response = scrape
    @manifest = parse
  end

  def iterate
    @manifest['items'].each do |item|
      self.bounding_box([10,710], :width => 520, :height => 650) do
        item['items'].each do |item_depth2|
          item_depth2['items'].each do |item_depth3|
            image_url = item_depth3['body']['id']
            resize_image_url = image_url.gsub(/[^\/]*\/[^\/]*\/0/, "full/520,/0,")
            doc_image = open(resize_image_url)
            self.image doc_image, :fit => [520, 650], :position => :center, :vposition => :center
          end
        end
        
      end
        content = item['label']['@none'][0]
        self.draw_text content, :at => [500,30]
        footer
        self.start_new_page
    end 
  end

  def footer
    footer_content = "(c) The Victoria and Albert Museum"
    self.draw_text footer_content, :at => [0,30]
  end

  private

  def scrape
    HTTParty.get(@url)
  end

  def parse
    JSON.parse(@response.body)
  end

end

test = ManifestPDF_V3.new('https://iiif.vam.ac.uk/collections/MSL:1876:Forster:141:I/manifest.json')
test.iterate
test.save_as('self.pdf')
