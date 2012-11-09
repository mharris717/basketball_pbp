module BasketballPbp
  class SavedEvent
    include Mongoid::Document
    include Mongoid::Timestamps
    %w(pts reb ast blk turn stl).each do |f|
      field f, :type => Fixnum
    end
    field :player
    field :game
    field :team
    field :event_type
    field :time

    #index :game
    #index :player
  end
end