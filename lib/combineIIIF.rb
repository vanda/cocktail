# This uses the prawn mixin
require 'prawn'
require 'httparty'
require 'open-uri'

class ManifestPDF_V3
  include Prawn::View

  attr_accessor :url, :response, :manifest, :layout, :padding, :width, :height, 
                :footer_height, :footer_bb_width, :footer_padding

  def initialize(url, layout = 'portrait', padding = 10)
    @url = url
    @layout = layout.to_sym
    @document = Prawn::Document.new(page_layout: @layout, page_size: 'A4')
    @response = scrape
    @manifest = parse
    @padding = padding
    set_measurements
    iterate
  end

  def iterate
    @manifest['items'].each do |item|
      bounding_box([@padding, @bb_top], width: @bb_width, height: @bb_height) do
        item['items'].each do |item_depth2|
          item_depth2['items'].each do |item_depth3|
            image_url = item_depth3['body']['id']
            resize_image_url = image_url.gsub(/[^\/]*\/[^\/]*\/0/, "full/520,/0,")
            doc_image = open(resize_image_url)
            image doc_image, fit: [@bb_width, @bb_height], position: :center, vposition: :center
          end
        end
      end
      image_label = item['label']['@none'][0]
      footer(image_label)
    end
  end

  def footer(image_label)
    bounding_box([@footer_padding, @footer_height], width: @footer_bb_width, height: @footer_height) do
      footer_content = "\u{00A9} The Victoria and Albert Museum"
      text footer_content, align: :left
    end
    bounding_box([@bb_width / 2, @footer_height], width: @footer_bb_width, height: @footer_height) do
      text image_label, align: :right
    end
    start_new_page
  end

  private

  def scrape
    HTTParty.get(@url, verify: false)
  end

  def parse
    JSON.parse(@response.body)
  end

  def set_measurements
    @width = @layout == :portrait ? 523 : 770
    @bb_width = @width - 2 * @padding
    @height = @layout == :portrait ? 770 : 523
    @bb_top = @height
    @bb_height = @height - (2 * @padding) - 50
    @footer_height = 30
    @footer_padding = 50
    @footer_bb_width = (@bb_width - 2 * @footer_padding) / 2
  end

  def get_manifest_version
    version_url = @manifest['context']
    regex = /presentation\/(\d)/
    manifest_version = version_url.match(regex)[0]
    puts manifest_version
  end
end

test = ManifestPDF_V3.new('https://iiif.vam.ac.uk/collections/MSL:1876:Forster:141:I/manifest.json', 'portrait', 0)
test.save_as('v3.pdf')
