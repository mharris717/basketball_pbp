module BasketballPbp
  class Play
    include FromHash
    attr_accessor :line
    fattr(:parsed) do 
      res = PbpFullParser.new.parse(line.downcase.strip) 
      #if !res && !known_bad_event?
      #  raise "|" + line.downcase.strip + "|"
      #end
      res
    end
    def team
      parsed.team_score.team.text_value
    end
    def game
      parsed.game.text_value
    end
    def time
      parsed.time.text_value
    end
    def other_team
      str = game[-6..-1]
      ([str[0..2],str[3..-1]] - [team]).first
    end
    def known_bad_event?
      line =~ /jump ball/i or line =~ /(substitution|technical|timeout|ejection)/i or line =~ /end of/i or line =~ /illegal screen/i
    end
    def events
      res = []
      return [] if known_bad_event?
      return [] unless parsed
      raise line if !parsed
      #raise parsed.inspect unless parsed.respond_to?(:first_event)
      fe = parsed.first_event
      ae = (parsed.respond_to?(:ae) && parsed.ae.text_value != '') ? parsed.ae : nil
      #puts ae.inspect if ae

      mm = nil
      mm = fe.mm.andand.modifier.andand.text_value if fe.mm.text_value.strip != ''
      res << Event.new(:player => fe.player.text_value, :raw_event_type => fe.event_type.text_value, :made_missed => mm, :team => team, :game => game, :time => time)

      if ae
        res << Event.new(:player => ae.player.text_value, :raw_event_type => ae.event_type.text_value, :team => team, :game => game, :time => time) 
        res.last.team = other_team if res.last.stl == 1
      end

      res

    end
  end
end