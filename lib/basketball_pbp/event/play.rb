module BasketballPbp
  module Play
    module MakeEvents
      def new_event(event,ops={})
        base = {:player => event.player.text_value, :raw_event_type => event.event_type.text_value}
        base = base.merge(:team => team, :game => game, :time => time)
        ops = base.merge(ops)
        Event.new(ops)
      end
      def made_missed
        fe = parsed.first_event
        (fe.mm.text_value.strip != '') ? fe.mm.andand.modifier.andand.text_value : nil
      end
      def events
        res = []
        return [] if known_bad_event?
        return [] unless parsed
        raise line if !parsed

        first_event = parsed.first_event
        addl_event = (parsed.respond_to?(:ae) && parsed.ae.text_value != '') ? parsed.ae : nil

        res << new_event(first_event,:made_missed => made_missed)

        if addl_event
          e = new_event(addl_event)
          e.team = other_team if e.stl == 1
          res << e
        end

        res
      end
    end
    
    class Base
      include FromHash
      include MakeEvents
      attr_accessor :line
      fattr(:parsed) do 
        parser_class.new.parse(line.downcase.strip) 
      end
      
      def team
        parsed.team_score.team.text_value.upcase
      end
      fattr(:teams) do
        str = game[-6..-1]
        [str[0..2].upcase,str[3..-1].upcase]
      end
      def other_team
        raise "no other team #{teams.inspect} #{team}" unless teams.include?(team)
        (teams - [team]).first
      end
      def known_bad_event?
        line =~ /jump ball/i or line =~ /(substitution|technical|timeout|ejection)/i or line =~ /end of/i or line =~ /illegal screen/i
      end
      
      
    end
    
    class Full < Base
      def parser_class; PbpFullParser; end
      
      def game
        parsed.game.text_value
      end
      def time
        parsed.time.text_value
      end
    end
    
    class Row < Base
      attr_accessor :row
      def parser_class; PbpEntryParser; end
      
      def line
        row['Entry']
      end
      def game
        row['GameID']
      end
      def time
        row['TimeRemaining']
      end
    end
  end
end