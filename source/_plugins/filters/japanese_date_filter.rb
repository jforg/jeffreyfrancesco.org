require 'time'

module Jekyll
  module JapaneseDateFilter

    def convert_datetime(datetime)
      datetime.is_a?(String) ? Time.parse(datetime) : datetime
    end

    def japanese_date(datetime)
      datetime = convert_datetime(datetime)
      year  = datetime.year.to_s << '年'
      month = datetime.month.to_s << '月'
      day   = datetime.day.to_s << '日'
      year << month << day
    end

    def japanese_time(datetime)
      datetime = convert_datetime(datetime)
      hour = datetime.hour.to_s << '時'
      min  = datetime.min
      min == 0 ? hour : hour << min.to_s << '分'
    end

    def japanese_datetime(datetime)
      datetime = convert_datetime(datetime)
      date = japanese_date(datetime)
      time = japanese_time(datetime)
      date << ' ' << time
    end

  end
end
Liquid::Template.register_filter(Jekyll::JapaneseDateFilter)
