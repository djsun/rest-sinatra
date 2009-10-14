require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/helpers/sources')

describe "Sources" do
  
  describe "DSL methods" do
    before do
      @config = Sources.instance_variable_get("@r")
    end

    it "name should be 'sources'" do
      @config[:name].should == "sources"
    end

    it "model should be Source" do
      @config[:model].should == Source
    end
    
    it "resource should be Sources" do
      @config[:resource].should == Sources
    end

    it "read_only should be empty" do
      @config[:read_only].should == []
    end

    it "callbacks should be empty" do
      @config[:callbacks].should == {}
    end
  end

  describe "actions" do
    before do
      @actions = Sources.actions
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
    
      it "exactly 2 actions" do
        @acts.length.should == 2
      end
    end
    
    describe "post" do
      before do
        @acts = @actions[:post]
      end

      it "post /?" do
        @acts.should include("/?")
      end

      it "exactly 1 action" do
        @acts.length.should == 1
      end
    end
    
    describe "put" do
      before do
        @acts = @actions[:put]
      end

      it "put /:id/?" do
        @acts.should include("/:id/?")
      end

      it "exactly 1 action" do
        @acts.length.should == 1
      end
    end
    
    describe "delete" do
      before do
        @acts = @actions[:delete]
      end

      it "delete /:id/?" do
        @acts.should include("/:id/?")
      end

      it "exactly 1 action" do
        @acts.length.should == 1
      end
    end
  end

end
