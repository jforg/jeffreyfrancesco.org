require 'cgi'
require_relative '../helpers/plugin_helper.rb'

module Jekyll
  class AutoTitleTag < Liquid::Tag

    DEFAULTS = {
      'separator' => '|',
      'templates' => {
        'default'  => '#{page_title}',
        'category' => 'Category: #{page_title}',
        'tag'      => 'Tag: #{page_title}',
        'year'     => 'Year: #{year}',
        'month'    => 'Month: #{month_name} #{year}',
        'day'      => 'Day: #{month_name} #{day} #{year}',
        'home'     => '#{site_title}'
      }
    }

    def initialize(tag_name, text, tokens)
      super
      @output_format = text
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

      # Set suffix
      separator = config['separator']
      site_name = site['title']
      suffix = type == 'home' ? "" : " #{separator} #{site_name}"

      # Set template variables
      vars = {
        'site_title'   => site_name,
        'page_title'   => page['title'] || ''
      }
      vars.merge!(PluginHelper.date_to_hash(page['date'])) if page['date']
      vars['category_name'] = PluginHelper.get_category_name(page['title']) if page['type'] == 'category'

      # Process template
      filled = PluginHelper.fill_template(template, vars)

      # Escape HTML special chars and return
      output_title(PluginHelper.escape_once(filled), suffix)
    end

    def output_title(title, suffix)
      "<title>#{title}#{suffix}</title>"
    end

  end
end

Liquid::Template.register_tag('auto_title', Jekyll::AutoTitleTag)
