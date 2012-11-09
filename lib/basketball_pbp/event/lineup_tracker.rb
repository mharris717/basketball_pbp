module BasketballPbp
  
  class Lineup
    include FromHash
    fattr(:players) { [] }
    def method_missing
    end
  end
  
  class OnCourt
    include FromHash
    fattr(:lineups) do
      Hash.new { |h,k| h[k] = [] }
    end
    
    def set_from(oc)
      self.lineups!
      oc.lineups.keys.sort.each do |k|
        v = oc.lineups[k]
        lineups[k] = v.clone
      end
    end
    
    def add(team,player,ops={})
      return if player == 'team'
      lineups[team] = (lineups[team] + [player]).uniq.sort
      #raise "adding #{player} makes #{lineups[team].inspect} #{ops[:event]}" if !ops[:sub] && lineups[team].size > 5
    end
    
    def remove(team,player,ops={})
      lineups[team] = (lineups[team] - [player])
    end
    
    def to_s
      nums = lineups.values.map { |x| x.size }.join(" ")
      nums + " " + lineups.map do |k,v|
        "#{k}: " + v.join(",").rpad(43)
      end.join(" | ")
    end
  end
  
  class OcEvent
    include FromHash
    attr_accessor :event
    fattr(:oc) do
      OnCourt.new
    end
    
    def bad?
      oc.lineups.values.any? { |x| x.size != 5 } && !event.sub?
    end
  end
  
  
  class QuarterLineupTracker
    include FromHash
    fattr(:events) { [] }
    
    def top_down(oc_events)
      last_oc = nil
      oc_events.each do |oce|
        oce.oc.set_from(last_oc) if last_oc
        if oce.event.event_type == 'sub_in'
          oce.oc.add oce.event.team,oce.event.player,:sub => true, :event => oce.event.raw_line
        elsif oce.event.event_type == 'sub_out'
          oce.oc.remove oce.event.team,oce.event.player,:sub => true, :event => oce.event.raw_line
        else
          oce.oc.add oce.event.team,oce.event.player,:sub => false, :event => oce.event.raw_line
        end
        last_oc = oce.oc
      end
    end
    
    def bottom_up(oc_events)
      last_oc = nil
      oc_events.reverse.each do |oce|
        oce.oc.set_from(last_oc) if last_oc
        if oce.event.event_type == 'sub_in'
          oce.oc.remove oce.event.team,oce.event.player,:sub => true, :event => oce.event.raw_line
        elsif oce.event.event_type == 'sub_out'
          oce.oc.add oce.event.team,oce.event.player,:sub => true, :event => oce.event.raw_line
        end
        last_oc = oce.oc
      end
    end
    
    fattr(:oc_events) do
      res = events.sort_by { |x| [x.time,x.sub? ? 0 : 1] }.reverse.map { |e| OcEvent.new(:event => e) }
      top_down(res)
      bottom_up(res)
      res
    end
  end
  
  class LineupTracker
    include FromHash
    fattr(:events) { [] }
    fattr(:trackers) do
      events.group_by { |x| x.quarter }.values.map { |x| QuarterLineupTracker.new(:events => x) }
    end
    fattr(:oc_events) do
      trackers.map { |x| x.oc_events }.flatten
    end
  end
end