# frozen_string_literal: true

require 'linguist'
require 'nokogiri'

class GithubPolyglot
  # Generates SVG for language stats
  class SVG
    attr_reader :width, :height, :radii

    # @param [Hash] languages Maps language name symbols to amounts.
    # @param [Integer, Float] width The width of the language bar
    # @param [Integer, Float] height The height of the language bar
    # @param [Integer, Float] radii The radii of language bar ends
    def initialize(languages, width: 300, height: 8, radii: 5)
      @languages = languages
      @width = width
      @height = height
      @radii = radii
    end

    # Creates an SVG string
    def generate
      mask_id = 'mask'
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.svg(xmlns: 'http://www.w3.org/2000/svg', width: width, height: height, viewBox: view_box) do
          body(xml, mask_id)
        end
      end

      builder.to_xml
    end

    # Alias for radii
    def radius
      radii
    end

    private

    # The view box for the SVG
    def view_box
      [0, 0, width, height].map(&:to_s).join(' ')
    end

    # Builds the xml body
    def body(xml, mask_id)
      xml.defs do
        mask(xml, mask_id)
      end
      language_group(xml, mask_id)
    end

    # Builds the mask for the rounded corners.
    def mask(xml, id)
      xml.mask(id: id) do
        xml.rect(x: 0, y: 0, width: width, height: height, rx: radius, ry: radius, fill: 'white')
      end
    end

    # Builds the language bar
    def language_group(xml, mask_id)
      xml.g(mask: "url(##{mask_id})") do
        language_x = 0.0

        sorted_languages.each do |language, amount|
          language_x = language_entry(xml, language_x, language, amount)
        end
      end
    end

    # Builds a single language entry for the language bar
    # @return [Integer, Float] The new offset on the X-axis for the next language entry
    def language_entry(xml, x_offset, language, amount)
      ratio = amount / total_amount
      language_width = width * ratio
      fill = color(language)
      return x_offset unless fill

      xml.rect(x: x_offset, y: 0, width: language_width, height: height, fill: fill)

      x_offset + language_width
    end

    # Returns the languages sorted by amount.
    def sorted_languages
      @sorted_languages ||= @languages.sort_by { |_, amount| -amount }
    end

    # Gets the total amount for languages.
    def total_amount
      @total_amount ||= @languages.values.sum.to_f
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
