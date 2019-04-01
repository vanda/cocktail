require 'extract_IIIF.rb'
require 'spec_helper'

RSpec.describe Cocktail do
  before(:each) do
    @response_v2 = File.read('testV2manifest.json')
    @response_v3 = File.read('testV3manifest.json')
    v2_options = { url: 'http://example2.com/testV2manifest.json',
                   layout: 'portrait',
                   padding: 10, filename: 'manifest',
                   title: false,
                   prefix: false,
                   title_path: './images/title.jpg',
                   font_size: 14,
                   padding_color: '000000',
                   footer_content: 'V2 Test',
                   custom_font_path: './font/vanda5.ttf',
                   canvas_start: nil,
                   canvas_length: nil }

    v3_options = { url: 'http://example3.com/testV3manifest.json',
                   layout: 'landscape',
                   padding: 10, filename: 'manifest',
                   title_path: './images/title.jpg',
                   font_size: 14,
                   padding_color: '000000',
                   footer_content: 'V3 Test',
                   custom_font_path: './font/vanda5.ttf' }

    stub_request(:get, /example2.com/)
      .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
      .to_return(status: 200, body: @response_v2, headers: {})

    stub_request(:get, /example3.com/)
      .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
      .to_return(status: 200, body: @response_v3, headers: {})

    @v2_cocktail = Cocktail.new(url: v2_options[:url],
                                layout: v2_options[:layout],
                                padding: v2_options[:padding],
                                size: v2_options[:font_size],
                                padding_color: v2_options[:padding_color],
                                prefix: v2_options[:prefix],
                                footer_content: v2_options[:footer_content],
                                custom_font_path: v2_options[:custom_font_path])

    @v3_cocktail = Cocktail.new(url: v3_options[:url],
                                layout: v3_options[:layout],
                                padding: v3_options[:padding],
                                size: v3_options[:font_size],
                                padding_color: v3_options[:padding_color],
                                prefix: v3_options[:prefix],
                                footer_content: v3_options[:footer_content],
                                custom_font_path: v3_options[:custom_font_path])
  end

  describe 'External HTTPPARTY request' do
    it 'queries a V2 manifest' do
      uri = URI('http://example2.com/testV2manifest.json')
      v2_response = Net::HTTP.get(uri)
      expect(v2_response).to be_an_instance_of(String)
      expect(v2_response).to include('http://iiif.io/api/presentation/2/context.json')
      expect(v2_response).to match(@response_v2)
    end

    it 'queries a V3 manifest' do
      uri = URI('http://example3.com/testV3manifest.json')
      v3_response = Net::HTTP.get(uri)
      expect(v3_response).to be_an_instance_of(String)
      expect(v3_response).to include('http://iiif.io/api/presentation/3/context.json')
      expect(v3_response).to match(@response_v3)
    end
  end

  describe 'Manifest version' do
    it 'identifies a V2 manifest' do
      expect(@v2_cocktail.manifest_version).to match(2)
    end

    it 'identifies a V3 manifest' do
      expect(@v3_cocktail.manifest_version).to match(3)
    end
  end
end
