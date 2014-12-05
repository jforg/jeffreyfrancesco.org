# sort_filter.rb
# site.tags を条件で並び替える Jekyll プラグイン

module Jekyll
  # 記事の多い順に並べ替え
  module SortByPopular
    def sort_by_popular(input)
      if input.is_a? Hash
        output = input.sort { |a, b | b[1].size <=> a[1].size }
        Hash[output]
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
      else
        input
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::SortByPopular)
Liquid::Template.register_filter(Jekyll::SortByName)
