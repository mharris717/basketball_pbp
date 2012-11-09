module BasketballPbp
  class Event
    include FromHash
    attr_accessor :player, :raw_event_type, :made_missed, :team, :game, :time, :filename, :raw_line
    def event_type
      return "free throw" if raw_event_type =~ /free throw/i
      raw_event_type
    end
    def made
      return true if made_missed == 'made'
      return false if made_missed == 'missed'
      nil
    end
    def pts
      return 1 if event_type =~ /free throw/i && made != false
      return 3 if event_type =~ /3pt/ && made
      return 2 if made
      0
    end
    def reb
      (event_type =~ /rebound/i) ? 1 : 0
    end
    def to_s
      "#{player} #{event_type} #{made} #{points}"
    end
    def ast
      (event_type == 'assist') ? 1 : 0
    end
    def blk
      (event_type == 'block') ? 1 : 0
    end
    def turn
      (event_type == 'turnover') ? 1 : 0
    end
    def stl
      (event_type == 'steal') ? 1 : 0
    end
    
    def sub?
      %w(sub_in sub_out).include?(event_type)
    end
    
    def quarter
      return 5 if time[0..0] == '-'
      min = time.split(":")[1].to_i
      return 1 if min >= 36
      return 2 if min >= 24
      return 3 if min >= 12
      4
    end

    def save!
      res = SavedEvent.new
      %w(pts reb ast blk turn stl player game team event_type time filename).each do |f|
        res.send("#{f}=",send(f))
      end
      res.save!
    end
  end
end