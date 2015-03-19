module Jekyll
  class RenderBreadcrumbsTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @separator = text.strip
    end

    def render(context)
      @site = context.registers[:site]
      @page = context.registers[:page]
      @url  = @page['url']
      @type = @page['type']

      sep   = @separator.empty? ? " &gt; " : " #@separator "
      items = breadcrumbs_items
      home  = %!<a href="/">ホーム</a>!

      # Process home
      return home if items.empty?
      breadcrumbs = [home]

      # Process breadclumbs exclude last item
      until items.size == 1
        item = items.shift
        item_name = get_parent_title(item[:url]) || process_parent_title(item[:name])
        breadcrumbs << %!<a href="#{item[:url]}">#{item_name}</a>!
      end

      # Process last item
      last_item = items.shift
      last_item_url = drop_index_html(@url)
      last_item_name = case @type
      when 'year', 'month', 'day'
        date_archive_title
      when 'category'
        category_archive_title
      when 'tag'
        tag_archive_title
      else
        @page['title']
      end
      breadcrumbs << %!<a href="#{last_item_url}">#{last_item_name}</a>!

      # Output
      breadcrumbs.join sep
    end

    def breadcrumbs_items
      items = []
      # This is ok, because first bit is always ''.
      @url.split('/').inject do |path, token|
        break if token == 'index.html'
        path << token
        path << '/'
        url = '/' << path
        items << { name: token, url: url }
        path
      end
      items
    end

    def get_parent_title(url)
      url_alt = url + 'index.html'
      matched_page = @site.pages.select do |item|
        item.url == url || item.url == url_alt
      end.shift

      matched_page ? matched_page['title'] : nil
    end

    def process_parent_title(name)
      if ['year', 'month', 'day'].include? @type
        date = @page['date']
        name.match(/\d{4}/) ? date.year.to_s << '年' : date.month.to_s << '月'
      else
        name
      end
    end

    def drop_index_html(url)
      url.gsub(/index\.html$/, '')
    end

    def date_archive_title
      date = @page['date']
      case @type
      when 'year'
        date.year.to_s  << '年'
      when 'month'
        date.month.to_s << '月'
      when 'day'
        date.mday.to_s  << '日'
      end
    end

    def category_archive_title
      "すべて"
    end

    def tag_archive_title
      "#{@page['title']}"
    end

  end
end

Liquid::Template.register_tag('render_breadcrumbs', Jekyll::RenderBreadcrumbsTag)
