module Kramdown
  module Converter
    class Html < Base
      def generate_toc_tree(toc, type, attr)
        sections = Element.new(type, nil, attr.dup)
        sections.attr['id'] ||= 'markdown-toc'
        stack = []
        toc.each do |level, id, children|
          li = Element.new(:li, nil, nil, level: level)
          li.children << Element.new(:p, nil, nil, transparent: true)
          a = Element.new(:a, nil)
          a.attr['href'] = "##{id}"
          a.attr['id'] = "#{sections.attr['id']}-#{id}"
          a.attr['data-google-vignette'] = "false"
          a.children.concat(fix_for_toc_entry(Marshal.load(Marshal.dump(children))))
          li.children.last.children << a
          li.children << Element.new(type)

          success = false
          until success
            if stack.empty?
              sections.children << li
              stack << li
              success = true
            elsif stack.last.options[:level] < li.options[:level]
              stack.last.children.last.children << li
              stack << li
              success = true
            else
              item = stack.pop
              item.children.pop if item.children.last.children.empty?
            end
          end
        end
        until stack.empty?
          item = stack.pop
          item.children.pop if item.children.last.children.empty?
        end
        sections
      end

    end
  end
end
