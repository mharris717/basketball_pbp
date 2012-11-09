module BasketballPbp
  module PBPFile
    class Base
      attr_accessor :path
      include FromHash
      fattr(:dir) do
        path.split("/")[-2]
      end
      fattr(:short_filename) do
        path.split("/")[-2..-1].join("/")
      end
      def each_row
        CSV.foreach(path,:headers => true, :col_sep => delimiter) do |row|
          h = {}
          row.each do |k,v|
            h[k] = v
          end
          fill_row(h)
          h["filename"] = short_filename
          yield(h)
        end
      end
      def rows
        res = []
        each_row { |x| res << x }
        res
      end
      def save!
        PBPFile.coll.remove(:filename => short_filename)
        each_row do |row|
          PBPFile.coll.save(row)
        end
      end 
    end
  end
end