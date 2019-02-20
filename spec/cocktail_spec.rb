require 'extract_IIIF.rb'
require 'spec_helper'

RSpec.describe Cocktail do
  before(:each) do
    @response_v2 = File.read('testV2manifest.json')
    @response_v3 = File.read('testV3manifest.json')

    stub_request(:get, /example2.com/)
      .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
      .to_return(status: 200, body: @response_v2, headers: {})

    stub_request(:get, /example3.com/)
      .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
      .to_return(status: 200, body: @response_v3, headers: {})

    @v2_cocktail = Cocktail.new('http://example2.com/testV2manifest.json',
                                'portrait', 10, 14, '000000', false,
                                'V2 Test', './font/vanda5.ttf')

    @v3_cocktail = Cocktail.new('http://example3.com/testV3manifest.json',
      'landscape', 10, 14, '000000', false,
      'V3 Test', './font/vanda5.ttf')

  end

  describe 'External HTTPPARTY request' do
    it 'queries a V2 manifest' do
      uri = URI('http://example2.com/testV2manifest.json')
      v2_response = Net::HTTP.get(uri)
      expect(v2_response).to be_an_instance_of(String)
      expect(v2_response).to include("http://iiif.io/api/presentation/2/context.json")
      expect(v2_response).to match(@response_v2)
    end

    it 'queries a V3 manifest' do
      uri = URI('http://example3.com/testV3manifest.json')
      v3_response = Net::HTTP.get(uri)
      expect(v3_response).to be_an_instance_of(String)
      expect(v3_response).to include("http://iiif.io/api/presentation/3/context.json")
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
