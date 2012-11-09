module BasketballPbp
  module PBPFile 
    class CsvFile < Base
      include RowFill
      fattr(:game) do
        File.basename(path)[0..-5]
      end
      def fill_row(row)
        fill_row_base(row)
        row['game'] = game
      end
      def delimiter; ","; end
    end
  end
end