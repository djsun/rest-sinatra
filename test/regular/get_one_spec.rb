require File.expand_path(File.dirname(__FILE__) + '/../../test_controller_helper')

class SourcesGetOneControllerTest < RequestTestCase

  def app; DataCatalog::Sources end

  before do
    source = Source.create(
      :title => "The Original Data Source",
      :url   => "http://data.gov/original"
    )
    @id = source.id
    @fake_id = get_fake_mongo_object_id
  end

  shared "attempted GET source with :fake_id" do
    use "return 404 Not Found"
    use "return an empty response body"
  end

  shared "successful GET source with :id" do
    use "return 200 Ok"
    use "return timestamps and id in body"
  
    test "body should have correct text" do
      assert_equal "http://data.gov/original", parsed_response_body["url"]
    end
  end

  context_ "get /:id" do
    context "anonymous" do
      before do
        get "/#{@id}"
      end

      use "return 401 because the API key is missing"
    end

    context "incorrect API key" do
      before do
        get "/#{@id}", :api_key => "does_not_exist_in_database"
      end

      use "return 401 because the API key is invalid"
    end
  end
  
  %w(normal curator admin).each do |role|
    context "#{role} API key : get /:fake_id" do
      before do
        get "/#{@fake_id}", :api_key => primary_api_key_for(role)
      end

      use "attempted GET source with :fake_id"
    end
  end

  %w(normal curator admin).each do |role|
    context "#{role} API key : get /:id" do
      before do
        get "/#{@id}", :api_key => primary_api_key_for(role)
      end

      use "successful GET source with :id"
    end
  end

end
