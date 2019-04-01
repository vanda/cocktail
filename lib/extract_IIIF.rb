# This uses the prawn mixin
require 'prawn'
require 'httparty'
require 'open-uri'

class Cocktail
  include Prawn::View
  Prawn::Font::AFM.hide_m17n_warning = true

  attr_accessor :url, :response, :manifest, :layout, :padding, :width,
                :height, :padding_color, :include_prefix, :footer_height,
                :footer_bb_width, :footer_padding, :manifest_version,
                :canvases, :footer_content

  def initialize(opts = {})
    @url = opts[:url]
    @layout = opts[:layout].to_sym
    @padding_color = opts[:padding_color]
    @padding = opts[:padding]
    @font_size = opts[:size]
    @include_prefix = opts[:prefix]
    @footer_content = opts[:footer_content]
    @document = Prawn::Document.new(page_layout: @layout, page_size: 'A4', margin: 20)
    update_font(opts[:custom_font_path]) unless opts[:custom_font_path].empty?
    @response = scrape
    @manifest = parse
    set_measurements_a4
    set_manifest_version
    @canvases = []
  end

  def insert_title(location = './images/title.jpg')
    image_center(location)
    start_new_page
  end

  def manifest_extract
    @manifest_version == 2 ? v2_extract : v3_extract
  end

  def full_page_generation
    array = @canvases
    page_generation(array)
  end

  def range_page_generation(start, length)
    array = @canvases[start, length]
    page_generation(array)
  end

  # private

  def scrape
    HTTParty.get(@url, verify: false)
  end

  def parse
    JSON.parse(@response.body)
  end

  def page_generation(canvas_array)
    canvas_array.each_with_index do |item, index|
      bounding_box([@padding, @bb_top], width: @bb_width, height: @bb_height) do
        fill_bounding
        doc_image = image_resize(item[:image_url])
        image_center(doc_image)
      end
      footer(item[:image_label])
      start_new_page unless index == canvas_array.size - 1
    end
  end

  def set_measurements_a4
    @width = @layout == :portrait ? 555 : 802
    @bb_width = @width - (2 * @padding)
    @height = @layout == :portrait ? 802 : 555
    @bb_top = @height
    @bb_height = @height - (2 * @padding)
    @footer_height = 15
    @footer_padding = 20
    @footer_bb_width = (@bb_width - 2 * @footer_padding) / 2
  end

  def update_font(custom_font_path)
    font_families.update('custom_font' => { normal: custom_font_path })
    font 'custom_font'
  end

  def set_manifest_version
    # V3 returns an array V2 is just a string
    version_url = @manifest['@context']
    version_url = version_url[1] if version_url.is_a?(Array)
    regex = %r{presentation/(\d)}
    @manifest_version = version_url.match(regex)[1].to_i
  end

  def v2_extract
    @manifest['sequences'].each do |sequence|
      sequence['canvases'].each do |canvas|
        @image_label = canvas['label']['@value'] ? canvas['label']['@value'] : canvas['label']
        canvas['images'].each do |image|
          @image_url = image['resource']['@id']
        end
        @canvases.push(image_url: @image_url, image_label: @image_label)
      end
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
      @canvases.push(image_url: @image_url, image_label: image_label)
    end
  end

  def fill_bounding
    stroke do
      fill_and_stroke_rounded_rectangle [0, @bb_height], @bb_width, @bb_height, 1
      fill_color @padding_color
    end
  end

  def footer(image_label)
    bounding_box([@footer_padding, @footer_height + @padding + 15], width: @footer_bb_width, height: @footer_height) do
      left_footer = "\u{00A9} #{@footer_content}"
      text left_footer, align: :left, color: 'FFFFFF', size: @font_size
    end
    bounding_box([@bb_width / 2, @footer_height + @padding + 15], width: @footer_bb_width, height: @footer_height) do
      text label_prefix(image_label), align: :right, color: 'FFFFFF', size: @font_size
    end
  end

  def label_prefix(label, prefix = 'ff.')
    @prefix = prefix
    @include_prefix ? label.gsub(/^\d+[vr]/, "#{@prefix} \\0") : label
  end

  def image_center(image_url)
    doc_image = open(image_url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)
    image doc_image, fit: [@bb_width, @bb_height], position: :center, vposition: :center
  end

  def image_resize(image_url)
    # default to max available size
    new_size = '/full/full/0,'
    image_url.gsub(/(\/)(full|[\d,]+)\1(full|\d[\d,]+)\1(\d+)/, new_size)
  end
end
