BP = BasketballPbp

filename = "data/AllData201203032316/sample_pbp.txt"
file = BP::PBPFile::RawFile.new(:path => filename)
file.rows[0...20].each { |x| puts x.inspect }