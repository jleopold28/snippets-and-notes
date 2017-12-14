# cron type
class Cron < TypeBase
  def has_entry?(user = nil, entry)
    minute, hour, daymonth, month, dayweek, cronentry = /([\d\,\*\-\/]+)\s([\d\,\*\-\/]+)\s([\d\,\*\-\/]+)\s([\d\,\*\-\/]+)\s([\d\,\*\-\/]+)\s(.*)/.match(entry).captures
    HashDumper.insert_hash('cron', cronentry, 'minute' => minute, 'hour' => hour, 'daymonth' => daymonth, 'month' => month, 'dayweek' => dayweek, 'user' => user)
  end

  def to_s
    'Cron'
  end
end

def cron(*args)
  Cron.new(args.first)
end
