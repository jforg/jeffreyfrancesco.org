require_relative '../helpers/plugin_helper.rb'

module Jekyll
  module ExcerptalizeFilter
    def excerptalize(input, length = 128, omission = '…', escape = true)
      PluginHelper.excerptalize(input, { length: length, omission: omission, escape: escape})
    end
  end
end
Liquid::Template.register_filter(Jekyll::ExcerptalizeFilter)
