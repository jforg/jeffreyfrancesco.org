# tag_generator.rb
# タグ別アーカイブページを出力する Jekyll プラグイン

module Jekyll
  class TagPage < Page

    def initialize(site, base, dir, tag)
      @site = site
      @base = base
      @dir  = dir

      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'tag.html')

      self.data['title'] = "タグ &ldquo;#{tag}&rdquo; が付けられた記事一覧"
      self.data['curr_tag'] = tag

    end
  end

  class TagPageGenerator < Generator
    safe true

    def generate(site)
      site.tags.keys.each do |t|
        tag_url = t.gsub(/\./, '_')
        tag_page = TagPage.new(site, site.source, File.join('tags', tag_url), t)
        tag_page.render(site.layouts, site.site_payload)
        site.pages << tag_page
      end
    end
  end
end
