require_relative '../helpers/plugin_helper.rb'

module Jekyll
  module XmlEscapeOnce
    def xml_escape_once(input)
      PluginHelper.escape_once(input)
    end
  end
end
Liquid::Template.register_filter(Jekyll::XmlEscapeOnce)
