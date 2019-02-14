# This uses the prawn mixin
require 'prawn'
require 'httparty'
require 'open-uri'

class ManifestPDF
  include Prawn::View
  Prawn::Font::AFM.hide_m17n_warning = true

  attr_accessor :url, :response, :manifest, :layout, :padding, :width, :height,
                :footer_height, :footer_bb_width, :footer_padding, :manifest_version, :manifest_summary

  def initialize(url, layout = 'portrait', padding = 10, size)
    @url = url
    @layout = layout.to_sym
    @document = Prawn::Document.new(page_layout: @layout, page_size: 'A4', margin: 20)
    @response = scrape
    @manifest = parse
    @padding = padding
    @font_size = size
    set_measurements
    set_manifest_version
    font_families.update('vanda5' => { normal: './font/vanda5.ttf' })
    font 'vanda5'
    @manifest_summary = []
  end

  def insert_title(location = './images/title.jpg')
    image_center(location)
    start_new_page
  end

  def extract
    if @manifest_version == 2
      v2_extract
    else
      v3_extract
    end
  end

  def page_generation
    @manifest_summary.each_with_index do |item, index|
      bounding_box([@padding, @bb_top], width: @bb_width, height: @bb_height) do
        fill_bounding
        doc_image = image_resize(item[:image_url])
        image_center(doc_image)
      end
      footer(item[:image_label])
      if index != @manifest_summary.size - 1 then start_new_page end
    end
  end

  # private

  def scrape
    HTTParty.get(@url, verify: false)
  end

  def parse
    JSON.parse(@response.body)
  end

  def set_measurements
    @width = @layout == :portrait ? 555 : 802
    @bb_width = @width - (2 * @padding)
    @height = @layout == :portrait ? 802 : 555
    @bb_top = @height
    @bb_height = @height - (2 * @padding)
    @footer_height = 15
    @footer_padding = 20
    @footer_bb_width = (@bb_width - 2 * @footer_padding) / 2
  end

  def set_manifest_version
    # V3 returns an array V2 is just a string
    version_url = @manifest['@context']
    version_url = version_url[1] if version_url.is_a?(Array)
    regex = /presentation\/(\d)/
    @manifest_version = version_url.match(regex)[1].to_i
  end

  def v2_extract
    @manifest['sequences'].each do |sequence|
      sequence['canvases'].each do |canvas|
        @image_label = canvas['label']['@value'] ? canvas['label']['@value'] : canvas['label']
        canvas['images'].each do |image|
          @image_url = image['resource']['@id']
        end
      end
      @manifest_summary.push(image_url: @image_url, image_label: @image_label)
    end
  end

  def v3_extract
    @manifest['items'].each do |item|
      item['items'].each do |item_depth2|
        item_depth2['items'].each do |item_depth3|
          @image_url = item_depth3['body']['id']
        end
      end
      image_label = item['label']['@none'][0]
      @manifest_summary.push(image_url: @image_url, image_label: image_label)
    end
  end

  def fill_bounding
    stroke_bounds
    stroke do
      fill_and_stroke_rounded_rectangle [0, @bb_height], @bb_width, @bb_height, 1
      fill_color '000000'
    end
  end

  def footer(image_label)
    bounding_box([@footer_padding, @footer_height + @padding + 15], width: @footer_bb_width, height: @footer_height) do
      footer_content = "\u{00A9} Victoria and Albert Museum, London"
      text footer_content, align: :left, color: 'FFFFFF', size: @font_size
    end
    bounding_box([@bb_width / 2, @footer_height + @padding + 15], width: @footer_bb_width, height: @footer_height) do
      text label_prefix(image_label), align: :right, color: 'FFFFFF', size: @font_size
    end
  end

  def label_prefix(label, prefix = 'ff.')
    @prefix = prefix
    label.gsub(/^\d+[vr]/, "#{@prefix} \\0")
  end

  def image_center(image_url)
    doc_image = open(image_url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)
    image doc_image, fit: [@bb_width, @bb_height], position: :center, vposition: :center
  end

  def image_resize(image_url)
    image_url.gsub(/(\/)(full|[\d,]+)\1(full|\d[\d,]+)\1(\d+)/, '/full/1500,/0,')
  end
end

# test3 = ManifestPDF.new('https://iiif.vam.ac.uk/collections/MSL:1876:Forster:141:I/manifest.json', 'portrait', 0, 14)
# test3.extract
# test3.insert_title
# test3.page_generation
# # puts test3.manifest_version
# test3.save_as('hash.pdf')

# test2 = ManifestPDF.new('https://iiif-int.vam.ac.uk/collections/MSL:1861:7446/manifest.json', 'landscape', 0)
# test2.iterate
# puts test2.manifest_version
# test2.save_as('v2.pdf')
