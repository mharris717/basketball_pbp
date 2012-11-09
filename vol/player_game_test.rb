players = BP::PlayerGame.make_for_game("20111225BOSNYK")
players.each do |pg|
  puts pg
end