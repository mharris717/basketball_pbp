sum = 0
BP::PBPFile.coll.find(:GameID => "20111225BOSNYK").each do |row|
  sum += BP::Play::Row.new(:row => row).events.size
end
puts sum