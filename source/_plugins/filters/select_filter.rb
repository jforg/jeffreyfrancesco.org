require 'date'

module Jekyll
  module SelectFilter
    def select_newer(posts)
      posts.select {|post| select_conditional post }.reverse!
    end

    def select_older(posts)
      posts.drop_while {|post| select_conditional post}
    end

    private

    def select_conditional(post)
      post.data.has_key?('schema') &&
        post.data['schema'].has_key?('start_at') &&
        Date.parse(post.data['schema']['start_at'].to_s) >= Date.today
    end
  end
end

Liquid::Template.register_filter(Jekyll::SelectFilter)
