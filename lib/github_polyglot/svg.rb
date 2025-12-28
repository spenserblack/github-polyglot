# frozen_string_literal: true

require 'linguist'
require 'nokogiri'

class GithubPolyglot
  # Generates SVG for language stats
  class SVG
    # @param [Hash] languages Maps language name symbols to amounts.
    def initialize(languages)
      @languages = languages
    end

    # Creates an SVG string
    def generate(width: 300, height: 8)
      total_amount = @languages.values.sum.to_f
      mask_id = 'mask'
      radius = 5
      view_box = [0, 0, width, height].map(&:to_s).join(' ')
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.svg(xmlns: 'http://www.w3.org/2000/svg', width: width, height: height, viewBox: view_box) do
          xml.defs do
            mask(xml, mask_id, width, height, radius)
          end

          xml.g(mask: "url(##{mask_id})") do
            language_x = 0.0

            @languages.each_pair do |language, amount|
              ratio = amount / total_amount
              language_width = width * ratio
              fill = color(language)
              next unless fill

              xml.rect(x: language_x, y: 0, width: language_width, height: height, fill: fill)
              language_x += language_width
            end
          end
        end
      end

      builder.to_xml
    end

    private

    # Builds the mask for the rounded corners.
    def mask(xml, id, width, height, radius)
      xml.mask(id: id) do
        xml.rect(x: 0, y: 0, width: width, height: height, rx: radius, ry: radius, fill: 'white')
      end
    end

    # Gets the color as a hex code string for a language.
    #
    # @param [String, Symbol] language The name of the language.
    def color(language)
      language = language.to_s

      Linguist::Language[language]&.color
    end
  end
end
