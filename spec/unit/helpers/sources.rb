require File.expand_path(File.dirname(__FILE__) + '/sinatra_stubs')

class Source ; end

class Sources
  include RestSinatra
  include SinatraStubs
  
  @r = resource "sources" do
    model Source

    permission_to_view :basic
    permission_to_modify :owner
  end
end
