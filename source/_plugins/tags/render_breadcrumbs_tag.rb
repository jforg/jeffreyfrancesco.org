require_relative '../helpers/plugin_helper.rb'

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

      schema_param = 'itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"'
      level = 2
      sep   = @separator.empty? ? " &gt; " : " #@separator "
      items = breadcrumbs_items
      home  = %!<span id="bc1" #{schema_param} itemref="bc2"><a href="/" itemprop="url"><span itemprop="title">ホーム</span></a></span>!

      # Process home
      return %!<span id="bc1" #{schema_param}><mark itemprop="title">ホーム</mark><link itemprop="url" href="/" /></span>! if items.empty?
      breadcrumbs = [home]

      # Process breadclumbs exclude last item
      until items.size == 1
        item = items.shift
        # Skip process if url is '/tag/'
        next if item[:name] == 'tag'

        next_level = level + 1
        item_name = get_parent_title(item[:url]) || process_parent_title(item[:name])
        item_url  = item[:url]
        breadcrumbs << %!<span id="bc#{level}" #{schema_param} itemprop="child" itemref="bc#{next_level}"><a href="#{item_url}" itemprop="url"><span itemprop="title">#{item_name}</span></span></a>!
        level += 1
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
        PluginHelper.escape_once(@page['title'])
      end
      breadcrumbs << %!<span id="bc#{level}" #{schema_param} itemprop="child"><mark itemprop="title">#{last_item_name}</mark><link itemprop="url" href="#{last_item_url}" /></span>!

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
      elsif name == 'tag'
        'Explore'
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
      "タグ: #{@page['title']}"
    end

  end
end

Liquid::Template.register_tag('render_breadcrumbs', Jekyll::RenderBreadcrumbsTag)
