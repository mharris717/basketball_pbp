module BasketballPbp
  module PBPFile
    class << self
      fattr(:coll) do
        conn = Mongo::Connection.new
        db = conn.db('basketball')
        db.collection('raw_pbp')
      end
    end
  end
end

%w(row_fill base files csv_file raw_file).each do |f|
  load File.dirname(__FILE__) + "/pbp_file/#{f}.rb"
end