# archive_generator.rb
# 年別アーカイブページを出力する Jekyll プラグイン

module Jekyll
  class ArchivePage < Page

    def initialize(site, base, dir, year)
      @site = site
      @base = base
      @dir  = dir

      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'year.html')

      self.data['title'] = "#{year}年に公開された記事一覧"
      self.data['curr_year'] = year

    end
  end

  class ArchivePageGenerator < Generator
    safe true

    def generate(site)
      site.archives.keys.each do |y|
        archive = ArchivePage.new(site, site.source, y.to_s, y)
        archive.render(site.layouts, site.site_payload)
        site.pages << archive
      end
    end
  end
end
