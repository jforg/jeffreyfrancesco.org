require 'cgi'

module PluginHelper

  module Standard
    require 'liquid'
    extend Liquid::StandardFilters
  end

  class << self

    CATEGORY_NAME = { weblog: 'Talkin’ About J.F.', info: 'Live &amp; Event Info' }

    def date_to_hash(date)
      {
        'year' => date.year.to_s,
        'month' => date.month.to_s,
        'month_name' => date.strftime('%B'),
        'day' => date.mday.to_s
      }
    end

    def escape_once(input)
      Standard.escape_once(input)
    end

    def excerptalize(input, config = {})
      tr_length   = config[:length] || 100
      tr_omission = config[:omission] || '...'
      html_escape = config[:escape] || true

      stripped  = self.strip_html(input)
      trimmed   = self.trim_spaces(stripped)
      unescaped = CGI.unescapeHTML(trimmed)
      output    = self.truncate(trimmed, tr_length, tr_omission)

      html_escape ? self.escape_once(output) : output
    end

    def fill_template(template, variables = {})
      variables.inject(template) do |result, token|
        break result if result.index('#{').nil?
        result.gsub(/\#\{#{token.first}\}/, token.last)
      end
    end

    def get_category_name(page_slug)
      CATEGORY_NAME[page_slug.to_sym] || page_slug
    end

    def strip_html(input)
      Standard.strip_html(input)
    end

    def trim_spaces(input)
      input.strip.gsub(/[ \n\t]+/, " ")
    end

    def truncate(input, length = 128, truncate_string = '…')
      Standard.truncate(input, length, truncate_string)
    end

  end

end
