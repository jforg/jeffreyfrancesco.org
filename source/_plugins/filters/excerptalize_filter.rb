require_relative '../helpers/plugin_helper.rb'

module Jekyll
  module ExcerptalizeFilter
    def excerptalize(input, length = 128, omission = '…', escape = true)
      options = { length: length, omission: omission, escape: escape}
      PluginHelper.excerptalize(input, options)
    end
  end
end
Liquid::Template.register_filter(Jekyll::ExcerptalizeFilter)
