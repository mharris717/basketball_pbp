%w(play event saved_event player_game).each do |f|
  load File.dirname(__FILE__) + "/event/#{f}.rb"
end