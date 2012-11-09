%w(pbp pbp_full pbp_entry).each do |f|
  Treetop.load "lib/basketball_pbp/grammar/#{f}"
end
