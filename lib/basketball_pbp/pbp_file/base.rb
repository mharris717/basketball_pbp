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
      def rows
        res = []
        CSV.foreach(path,:headers => true, :col_sep => delimiter) do |row|
          h = {}
          row.each do |k,v|
            h[k] = v
          end
          fill_row(h)
          h["filename"] = short_filename
          res << h
        end
        res
      end
      def save!
        rows.each do |row|
          PBPFile.coll.save(row)
        end
      end 
    end
  end
end