class Photo

  include MongoMapper::Document

  key :title,         String
  key :url,           String
  key :released,      Date
  timestamps!

end
