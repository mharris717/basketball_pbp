BP = BasketballPbp

puts BP::PBPFile.coll.count

#filename = "data/AllData201203032316/sample_pbp.txt"
filename = "data/AllData201203032316/playbyplay201203032316.txt"

file = BP::PBPFile::RawFile.new(:path => filename)
file.save!

puts BP::PBPFile.coll.count