BP = BasketballPbp

rows = BP::PBPFile.coll.find.limit(2000)

rows.each do |row|
  play = BP::Play::Row.new(:row => row)
  puts play.events.size
end