# ext.rb
# クラスメソッドを上書きして Jekyll の機能を拡張するためのプラグイン。
#
# とりあえず、`site.archives` に Posts を年月別でソートして入れてみた。
# 対応バージョン: v2.5.1

module Jekyll
  class Site

    def archives
      hash = Hash.new do |hash, key|
        hash[key]  = Hash.new { |hash, key| hash[key] = Array.new }
      end

      posts.each { |p| hash[p.date.year][p.date.month] << p }
      hash
    end

    def site_payload
      {
        "jekyll" => {
          "version" => Jekyll::VERSION,
          "environment" => Jekyll.env
        },
        "site"   => Utils.deep_merge_hashes(config,
          Utils.deep_merge_hashes(Hash[collections.map{|label, coll| [label, coll.docs]}], {
            "time"         => time,
            "posts"        => posts.sort { |a, b| b <=> a },
            "pages"        => pages,
            "static_files" => static_files.sort { |a, b| a.relative_path <=> b.relative_path },
            "html_pages"   => pages.select { |page| page.html? || page.url.end_with?("/") },
            "categories"   => post_attr_hash('categories'),
            "tags"         => post_attr_hash('tags'),
            "archives"     => archives,
            "collections"  => collections,
            "documents"    => documents,
            "data"         => site_data
        }))
      }
    end

  end
end
