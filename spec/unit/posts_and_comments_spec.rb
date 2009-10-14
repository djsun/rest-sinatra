require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
require File.expand_path(File.dirname(__FILE__) + '/helpers/posts.rb')
require File.expand_path(File.dirname(__FILE__) + '/helpers/comments.rb')

describe "Posts" do
  
  before do
    @config = Posts.instance_variable_get("@r")
  end
  
  describe "DSL methods" do
    it "resource should be 'posts'" do
      @config[:name].should == "posts"
    end

    it "model should be Post" do
      @config[:model].should == Post
    end

    it "resource should be Posts" do
      @config[:resource].should == Posts
    end

    it "read_only should be correct" do
      @config[:read_only].should == [:created_at, :updated_at]
    end

    it "callback :before_create should be correct" do
      @config[:callbacks][:before_save].call.should == "before saving posts"
    end
    
    it "callback :before_update should return nil" do
      @config[:callbacks][:before_update].should == nil
    end
  end

  describe "actions" do
    before do
      @actions = Posts.actions
    end
    
    describe "get" do
      before do
        @acts = @actions[:get]
      end

      it "get /?" do
        @acts.should include("/?")
      end

      it "get /:id/?" do
        @acts.should include("/:id/?")
      end

      it "get /:parent_id/comments/?" do
        @acts.should include("/:parent_id/comments/?")
      end

      it "get /:parent_id/comments/:child_id/?" do
        @acts.should include("/:parent_id/comments/:child_id/?")
      end

      it "exactly 4 actions" do
        @acts.length.should == 4
      end
    end

    describe "post" do
      before do
        @acts = @actions[:post]
      end
    
      it "post /?" do
        @acts.should include("/?")
      end

      it "post /:parent_id/comments/?" do
        @acts.should include("/:parent_id/comments/?")
      end
    
      it "exactly 2 actions" do
        @acts.length.should == 2
      end
    end

    describe "put" do
      before do
        @acts = @actions[:put]
      end
    
      it "put /:id/?" do
        @acts.should include("/:id/?")
      end
      
      it "put /:parent_id/comments/:child_id/?" do
        @acts.should include("/:parent_id/comments/:child_id/?")
      end
    
      it "exactly 2 actions" do
        @acts.length.should == 2
      end
    end

    describe "delete" do
      before do
        @acts = @actions[:delete]
      end
    
      it "delete /:id/?" do
        @acts.should include("/:id/?")
      end
      
      it "delete /:parent_id/comments/:child_id/?" do
        @acts.should include("/:parent_id/comments/:child_id/?")
      end
    
      it "exactly 2 actions" do
        @acts.length.should == 2
      end
    end
  end

end

describe "Comments" do
  
  before do
    @config = Comments.instance_variable_get("@r")
  end
  
  describe "DSL methods" do
    it "resource should be 'comments'" do
      @config[:name].should == "comments"
    end

    it "model should be Comment" do
      @config[:model].should == Comment
    end

    it "model should be Comments" do
      @config[:resource].should == Comments
    end

    it "read_only should be correct" do
      @config[:read_only].should == [:created_at]
    end

    it "callback :before_create should be correct" do
      @config[:callbacks][:before_save].call.should == "before saving comments"
    end
    
    it "callback :before_update should return nil" do
      @config[:callbacks][:before_update].should == nil
    end
  end
end
