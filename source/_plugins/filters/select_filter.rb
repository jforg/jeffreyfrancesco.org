require 'date'

module Jekyll
  module SelectFilter
    def select_newer(posts)
      posts.select {|post| select_conditional post }
    end

    def select_older(posts)
      posts.drop_while {|post| select_conditional post}
    end

    private

    def select_conditional(post)
      post.data.has_key?('event_meta') &&
        post.data['event_meta'].has_key?('date') &&
        Date.parse(post.data['event_meta']['date'].to_s) >= Date.today
    end
  end
end

Liquid::Template.register_filter(Jekyll::SelectFilter)
