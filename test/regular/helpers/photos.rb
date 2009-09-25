class Photos < Sinatra::Base
  include RestSinatra

  resource "photos" do

    model Photo

    read_only :created_at
    read_only :updated_at

  end

end
