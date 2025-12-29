# frozen_string_literal: true

require 'linguist'
require 'nokogiri'
require 'github_polyglot/svg/language_stats'

class GithubPolyglot
  # Generates SVG for language stats
  class SVG
    include LanguageStats

    # Width of the SVG image
    WIDTH = 300

    # Height of the language bar
    BAR_HEIGHT = 8

    # Padding underneath the language bar
    BAR_PADDING = 8

    # Radii of rounded elements
    RADII = 5

    # The name of the entry for remaining languages.
    OTHER_LANGUAGES = :Other

    # The default color to use if a language doesn't have a color
    DEFAULT_COLOR = '#EDEDED'

    # The CSS text that gets applied to the SVG.
    CSS = File.read(File.expand_path('svg.css', __dir__))

    # @param [Hash] languages Maps language name symbols to amounts.
    def initialize(languages)
      @languages = languages
    end

    # Creates an SVG string
    def generate
      mask_id = 'mask'
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.svg(xmlns: 'http://www.w3.org/2000/svg', width: width, height: height, viewBox: view_box) do
          xml.style(type: 'text/css') { xml.cdata(CSS) }
          body(xml, mask_id)
        end
      end

      builder.to_xml
    end

    # Gets the width of the SVG
    def width
      WIDTH
    end

    # Gets the height of the SVG
    def height
      BAR_HEIGHT + BAR_PADDING + stats_height
    end

    # Gets the radii of rounded elements
    def radii
      RADII
    end

    # Alias for radii
    def radius
      RADII
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
      language_stats(xml)
    end

    # Builds the mask for the rounded corners.
    def mask(xml, id)
      xml.mask('mask-type': 'luminance', id: id) do
        xml.rect(x: 0, y: 0, width: width, height: BAR_HEIGHT, rx: radius, ry: radius, fill: 'white')
      end
    end

    # Builds the language bar
    def language_group(xml, mask_id)
      xml.g(mask: "url(##{mask_id})") do
        language_x = 0.0
        summarized_languages.each do |language, amount|
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

      xml.rect(x: x_offset, y: 0, width: language_width, height: BAR_HEIGHT, fill: fill)

      x_offset + language_width
    end

    # Returns the languages sorted by amount.
    def sorted_languages
      @sorted_languages ||= @languages.sort_by { |_, amount| -amount }
    end

    # Returns the language entries, but groups the least popular under `:Other`.
    def summarized_languages
      return @summarized_languages if @summarized_languages

      languages = sorted_languages
      return @summarized_languages = languages if languages.length <= TOP_LANGUAGES

      @summarized_languages = languages.slice(0, TOP_LANGUAGES)
      @summarized_languages << [OTHER_LANGUAGES, languages[TOP_LANGUAGES..].inject(0) do |total, (_, amount)|
        total + amount
      end]
    end

    # Gets the total amount for languages.
    def total_amount
      @total_amount ||= @languages.values.sum.to_f
    end

    # Gets the color as a hex code string or CSS color for a language.
    #
    # @param [String, Symbol] language The name of the language.
    def color(language)
      return DEFAULT_COLOR if language == OTHER_LANGUAGES

      language = language.to_s

      Linguist::Language[language]&.color || DEFAULT_COLOR
    end

    # Gets the height of the language stats entries.
    def stats_height
      stats_rows * STAT_ROW_HEIGHT
    end

    # Gets the number of rows for language stats entries.
    def stats_rows
      # NOTE: + 1 because of the potential extra "Other" entry
      ((TOP_LANGUAGES + 1) / STATS_COLUMNS.to_f).ceil
    end
  end
end
