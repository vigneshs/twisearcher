module Tools
  def self.seconds_to_time(seconds)
    minutes = (seconds / 60).to_i
    hours = minutes / 60
    days = hours / 24
    weeks = days / 7
    days = days % 7
    hours = hours % 24
    minutes = minutes % 60
    seconds = (seconds % 60).to_i
    time = []
    time << "#{weeks}_#{'week'.pluralize(weeks)}" if weeks > 0
    time << "#{days}_#{'day'.pluralize(days)}" if days > 0
    time << "#{hours}_#{'hr'.pluralize(hours)}" if hours > 0
    time << "#{minutes}_#{'min'.pluralize(minutes)}" if minutes > 0
    time << "#{seconds}_#{'sec'.pluralize(seconds)}" if seconds > 0
    time << "0_secs" if time.empty?
    time.join(" ")
  end
end