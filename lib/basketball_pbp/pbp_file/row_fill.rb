module BasketballPbp
  module PBPFile
    module RowFill
      def parse_time(t,q)
        return 0 unless [1,2,3,4].include?(q)
        m,s = t.split(":").map { |x| x.to_i }
        res = m*60 + s
        res + (4-q)*720
      end
      def calc_dist(h)
        return nil unless h['x'] && h['y']
        x,y = h['x'].to_f,h['y'].to_f
        res = (x-25)**2 + (y-5.25)**2
        res**0.5
      end
      def fill_players(h)
        str = %w(a1 a2 a3 a4 a5 h1 h2 h3 h4 h5).map { |x| h[x] }.join("|")
        h['players'] = str
      end
      def fill_row_base(h)
        new_time = parse_time(h['time'],h['period'].to_i)
        h['elapsed'] = prev_time-new_time
        self.prev_time = new_time

        h['shot_distance'] = calc_dist(h)
        fill_players(h)
      end
      fattr(:prev_time) { 720*4 }
    end
  end
end