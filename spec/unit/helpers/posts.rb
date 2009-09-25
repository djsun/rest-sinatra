require File.expand_path(File.dirname(__FILE__) + '/sinatra_stubs')
require File.expand_path(File.dirname(__FILE__) + '/comments')

class Post ; end

class Posts
  include RestSinatra
  include SinatraStubs
  
  @r = resource "posts" do
    model Post

    read_only :created_at
    read_only :updated_at
    
    nested_resource Comments, :association => :comments
    
    callback :before_save do
      "before saving posts"
    end
  end
end
