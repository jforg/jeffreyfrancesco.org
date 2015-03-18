require 'cgi'
require_relative '../helpers/plugin_helper.rb'

module Jekyll
  class AutoDescriptionTag < Liquid::Tag

    DEFAULTS = {
      'truncate' => {
        'length'   => 100,
        'omission' => '...'
      },
      'templates' => {
        'default'  => '#{page_excerpt}',
        'category' => 'This is an archive of all articles filed under #{title}.',
        'tag'      => 'This is an archive of all articles tagged with #{title}.',
        'year'     => 'This is an archive of all articles published in #{year}.',
        'month'    => 'This is an archive of all articles published in #{month_name} #{year}.',
        'day'      => 'This is an archive of all articles published on #{month_name} #{day} #{year}.',
        'home'     => '#{site_description}'
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

      if site['auto_description'].nil?
        config = DEFAULTS
      else
        config = Utils.deep_merge_hashes(DEFAULTS, site['auto_description'])
      end

      # Set templates and current template-type
      type     = page['type'] ||= 'default'
      template = config['templates'][type]
      truncate_config = config['truncate']

      # Set template valiables
      vars = {
        'site_description' => site['description'].strip,
        'title' => page['title'] || ''
      }

      # Probably, page or post has excerpt. So processing clean it.
      vars['page_excerpt'] = process_excerpt(page['excerpt'], truncate_config) if page['excerpt']
      
      # Probably, post or date-based archives has date.
      vars.merge!(PluginHelper.date_to_hash(page['date'])) if page['date']

      # Process template
      description = PluginHelper.fill_template(template, vars)

      # Escape HTML special chars and return
      output_description(PluginHelper.escape_once(description))

    end

    def process_excerpt(excerpt, config)
      # First, strip HTML tags and continuous spaces
      stripped = PluginHelper.trim_spaces(PluginHelper.strip_html(excerpt))
      # Next, unescape HTML entities (because '途切れるから!' on next step)
      unescaped = CGI.unescapeHTML(stripped)
      # Last, truncate @length chars
      PluginHelper.truncate(stripped, config['length'], config['omission'])
    end

    def output_description(desc)
      xml_output = @output_format.match(/x(?:ht)?ml/).nil? ? '' : ' /'
      case @output_format
      when /meta/
        "<meta name=\"description\" content=\"#{desc}\"#{xml_output}>"
      when /ogp/
        "<meta property=\"og:description\" content=\"#{desc}\"#{xml_output}>"
      else
        desc
      end
    end

  end
end

Liquid::Template.register_tag('auto_description', Jekyll::AutoDescriptionTag)
