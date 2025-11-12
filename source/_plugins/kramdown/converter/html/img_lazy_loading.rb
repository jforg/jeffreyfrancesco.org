module Kramdown
  module Converter
    class Html < Base
      def convert_img(el, _indent)
        attr = el.attr.dup

        if !attr.key?('loading')
          attr['loading'] = 'lazy'
        end

        "<img#{html_attributes(attr)} />"
      end
    end
  end
end
