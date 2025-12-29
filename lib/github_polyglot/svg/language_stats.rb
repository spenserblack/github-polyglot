# frozen_string_literal: true

class GithubPolyglot
  class SVG
    # Helper for language stats
    module LanguageStats
      # The number of the most popular languages to show. If there are more than this
      # amount of languages, the least common get grouped under "Other" languages.
      TOP_LANGUAGES = 6

      # The number of columns in the language stats area.
      STATS_COLUMNS = 2

      # The height of a language stat row.
      STAT_ROW_HEIGHT = 20

      # Classes for the language name in language stats.
      LANGUAGE_NAME_CLASS = 'text-bold'

      # Class for the language percentage.
      LANGUAGE_PERCENTAGE_CLASS = 'muted'

      private

      # Builds the language stats entries
      def language_stats(xml)
        summarized_languages.each_with_index do |(language, amount), index|
          language_stat(xml, language, amount, index)
        end
      end

      # Adds the language stat to the SVG
      def language_stat(xml, language, amount, index)
        x, y = language_stats_coordinates(index)
        language_stat_circle(xml, language, x, y)
        x += radius * 4
        y += radius
        language_stat_text(xml, language, amount, x, y)
      end

      # Adds the circle for the language stat
      def language_stat_circle(xml, language, x_coord, y_coord)
        fill = color(language)
        xml.circle(cx: x_coord + radius, cy: y_coord + radius, r: radius, fill: fill)
      end

      # Adds the text for the language stat
      def language_stat_text(xml, language, amount, x_coord, y_coord)
        percentage = (amount * 100.0 / total_amount).round(1)
        xml.text_(x: x_coord, y: y_coord, 'dominant-baseline': 'middle') do
          xml.tspan(class: LANGUAGE_NAME_CLASS) do
            xml.text language.to_s
          end
          xml.tspan(class: LANGUAGE_PERCENTAGE_CLASS) { xml.text " #{percentage}%" }
        end
      end

      # Gets coordinates for where the language stats should be.
      def language_stats_coordinates(index)
        y_offset = BAR_HEIGHT + BAR_PADDING
        row_num = index / STATS_COLUMNS
        col_num = index % STATS_COLUMNS
        x = (width.to_f / STATS_COLUMNS) * col_num
        y = y_offset + (row_num * STAT_ROW_HEIGHT)
        [x, y]
      end
    end
  end
end
