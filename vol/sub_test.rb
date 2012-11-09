events = BP::Play.make_events_for_game("20111225BOSNYK")
puts events.size
puts events.select { |x| x.event_type == 'sub_out' }.size