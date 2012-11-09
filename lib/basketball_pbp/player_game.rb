module BasketballPbp
  class PlayerGame
    include Mongoid::Document
    include Mongoid::Timestamps
    %w(pts reb ast blk turn stl).each do |f|
      field f, :type => Fixnum
    end
    field :player
    field :game
    field :team
    def self.create_for_game(game)
      events = SavedEvent.where(:game => game)
      events.group_by { |x| [x.team,x.player] }.each do |ks,es|
        res = new(:player => ks[1], :team => ks[0], :game => game)
        %w(pts reb ast blk turn stl).each do |f|
          val = es.map { |x| x.send(f) }.sum
          res.send("#{f}=",val)
        end
        res.save!
      end
    end
  end
end