events = BP::Play.make_events_for_game("20111225BOSNYK")
tracker = BP::LineupTracker.new(:events => events)

class String
  def rpad(n)
    return self if length >= n
    pad = " " * (n - length)
    self + pad
  end
end

strs = []
tracker.oc_events.each do |oce|
  strs << "#{oce.bad? ? 'B' : ' '} #{oce.event.quarter} #{oce.event.time} #{oce.event.raw_line.rpad(85)} #{oce.oc}" #unless oce.event.sub?
end
File.create("events.txt",strs.join("\n"))

plus_minus = lambda do |player|
  sums = Hash.new { |h,k| h[k] = 0 }
  tracker.oc_events.each do |oce|
    if oce.oc.lineups['NYK'].include?(player)
      sums[oce.event.team] += oce.event.pts
    end
  end
  pm = sums['NYK'] - sums['BOS']
  puts "#{player}: #{pm}"
end

players = tracker.oc_events.map { |x| x.event }.select { |x| x.team == 'NYK' }.map { |x| x.player }.uniq
players.each do |player|
  plus_minus[player]
end

puts tracker.oc_events.map { |x| x.event.pts }.sum

events = tracker.oc_events.map { |x| x.event }.select { |x| x.player == 'anthony' }
events.group_by { |x| x.quarter }.each do |qtr,es|
  puts "#{qtr}: " + es.map { |x| x.pts }.sum.to_s
end