# sort_filter.rb
# site.tags を条件で並び替える Jekyll プラグイン

module Jekyll
  # 記事の多い順に並べ替え
  module SortByPopular
    def sort_by_popular(input)
      if input.is_a? Hash
        output = input.sort_by { |k, v | v.size }.reverse
        Hash[output]
      elsif input.is_a? Array
        input.sort_by { |i| i.posts.size }.reverse
      else
        input
      end
    end
  end
  # タグ名順に並べ替え
  module SortByName
    def sort_by_name(input)
      if input.is_a? Hash
        output = input.sort_by { |k, v| k }
        Hash[output]
      elsif input.is_a? Array
        input.sort_by { |i| i.title }
      else
        input
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::SortByPopular)
Liquid::Template.register_filter(Jekyll::SortByName)
