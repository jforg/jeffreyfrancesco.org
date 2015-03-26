require_relative '../helpers/plugin_helper.rb'

module Jekyll
  module ToCategoryName
    def to_category_name(input)
      PluginHelper.get_category_name(input)
    end
  end
end
Liquid::Template.register_filter(Jekyll::ToCategoryName)
