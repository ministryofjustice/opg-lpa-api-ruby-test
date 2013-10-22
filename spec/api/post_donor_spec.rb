require 'spec_helper'

describe Lpa::API do
  include Rack::Test::Methods

  def app
    Lpa::API
  end

  it "POST title, name" do
    json = { 'donor' => { 'title' => 'Mr', 'first_name' => 'James' } }
    post "/api/donor", json
    last_response.status.should == 201
    response = JSON.parse last_response.body
    response.except('_id').should == json['donor']
  end

end
