module BasketballPbp
  module PBPFile
    class Files
      include FromHash
      attr_accessor :dir
      fattr(:files) do
        Dir["#{dir}/*.csv"].map do |f|
          new(:path => f)
        end
      end
    end
  end
end