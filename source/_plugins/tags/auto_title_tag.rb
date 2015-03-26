require 'cgi'
require_relative '../helpers/plugin_helper.rb'

module Jekyll
  class AutoTitleTag < Liquid::Tag

    DEFAULTS = {
      'separator' => '|',
      'templates' => {
        'default'  => '#{page_title} #{separator} #{site_title}',
        'category' => 'Category: #{page_title} #{separator} #{site_title}',
        'tag'      => 'Tag: #{page_title} #{separator} #{site_title}',
        'year'     => 'Year: #{year} #{separator} #{site_title}',
        'month'    => 'Month: #{month_name} #{year} #{separator} #{site_title}',
        'day'      => 'Day: #{month_name} #{day} #{year} #{separator} #{site_title}',
        'home'     => '#{site_title}'
      }
    }

    def initialize(tag_name, text, tokens)
      super
      @attrs = text.empty? ? "" : " #{text.strip}"
    end

    def render(context)
      # Read Configurations
      site = context.registers[:site].config
      page = context.registers[:page]

      if site['auto_title'].nil?
        config = DEFAULTS
      else
        config = Utils.deep_merge_hashes(DEFAULTS, site['auto_title'])
      end

      # Set templates and current template-type
      type     = page['type'] ||= 'default'
      template = config['templates'][type]

      # Set template variables
      vars = {
        'separator'    => config['separator'],
        'site_title'   => site['title'],
        'page_title'   => page['title'] || ''
      }
      vars.merge!(PluginHelper.date_to_hash(page['date'])) if page['date']
      vars['category_name'] = PluginHelper.get_category_name(page['title']) if page['type'] == 'category'

      # Process template
      filled = PluginHelper.fill_template(template, vars)
      output = PluginHelper.escape_once(filled)

      "<title#{@attrs}>#{output}</title>"
    end

  end
end

Liquid::Template.register_tag('auto_title', Jekyll::AutoTitleTag)
