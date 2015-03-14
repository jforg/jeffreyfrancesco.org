module Jekyll
  module GroupByYear
    def group_by_year(input)
      input.group_by{|i| i.date.year}
    end
  end
  module GroupByMonth
    def group_by_month(input)
      input.group_by{|i| i.date.month}
    end
  end
end
Liquid::Template.register_filter(Jekyll::GroupByYear)
Liquid::Template.register_filter(Jekyll::GroupByMonth)
