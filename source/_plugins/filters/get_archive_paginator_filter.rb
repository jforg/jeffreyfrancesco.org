module Jekyll
  module GetArchivePaginator
    def get_archive_paginator(input)
      year  = input.to_i
      posts = @context.registers[:site].posts
      group = posts.docs.group_by{|i| i.date.year}
      years = group.keys.sort

      current_index = years.index(year)

      # `previous` is older year archives
      p = year != years.first ? years[current_index - 1] : nil
      # `next` is newer year archives
      n = year != years.last ? years[current_index + 1] : nil

      { "previous" => p, "next" => n }
    end
  end
end

Liquid::Template.register_filter(Jekyll::GetArchivePaginator)
