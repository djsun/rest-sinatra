require File.expand_path(File.dirname(__FILE__) + '/sinatra_stubs')

class Comment ; end

class Comments
  include RestSinatra
  include SinatraStubs
  
  @r = nestable_resource "comments" do
    model Comment
    
    read_only :created_at
    
    callback :before_save do
      "before saving comments"
    end
  end
end
