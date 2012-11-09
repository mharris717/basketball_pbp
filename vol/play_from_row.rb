BP = BasketballPbp

BP::SavedEvent.destroy_all

puts BP::PBPFile.coll.count

BP::PBPFile.coll.find.each_with_index do |row,i|
  BP::Play::Row.new(:row => row).save!
  puts "#{i} #{BP::SavedEvent.count}" if (i%1000) == 0
end

puts BP::SavedEvent.count