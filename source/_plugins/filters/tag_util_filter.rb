module Jekyll
  module TagUtility
    # タグを URL（絶対パス）に変換
    def tag_to_url(input)
      url_bit = input.gsub(/\./, '_')
      "/tags/#{url_bit}/"
    end
    # タグのリストをハイパーリンクのリストに変換
    def tags_to_links(input)
      if input.is_a? Array
        tag_links = input.map do |e|
          url = tag_to_url(e)
          "<a href=\"#{url}\">#{e}</a>"
        end
        tag_links
      else
        url = tag_to_url(input)
        "<a href=\"#{url}\">#{input}</a>"
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::TagUtility)
