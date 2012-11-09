%w(pbp pbp_full pbp_entry).each do |f|
  Treetop.load "lib/basketball_pbp/grammar/#{f}"
end

def parse_with(cls,line)
  $parsers ||= Hash.new { |h,k| h[k] = k.new }
  $parsers[cls].parse(line)
end
