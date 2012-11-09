module BasketballPbp
  module PBPFile
    class RawFile < Base
      attr_accessor :prev_game
      def fill_row(h)
        game = h['GameID']
        puts game if game != prev_game
        self.prev_game = game
      end
      def delimiter; "\t"; end
    end
  end
end