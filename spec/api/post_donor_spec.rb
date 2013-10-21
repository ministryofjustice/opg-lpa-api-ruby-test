require 'spec_helper'

describe Lpa::API do
  include Rack::Test::Methods

  def app
    Lpa::API
  end

  it "POST title, name" do
    json = { 'title' => 'Mr', 'first_name' => 'James' }
    post "/api/donor", json
    last_response.status.should == 201
    JSON.parse(last_response.body).should == json
  end

end
