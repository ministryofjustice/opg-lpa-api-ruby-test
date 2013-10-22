require 'spec_helper'

describe Lpa::API do
  include Rack::Test::Methods

  def app
    Lpa::API
  end

  describe 'POST donor title, first_name' do
    it "should return 400 error" do
      json = { 'donor' => { 'title' => 'Mr', 'first_name' => 'James' } }
      post "/api/donor", json
      last_response.status.should == 400
      response = JSON.parse last_response.body
      response.except('_id').should == {"messages"=>{"last_name"=>["can't be blank"]}}
    end
  end

  describe "POST donor title, name, and address postcode" do
    it 'should return 200 with JSON' do
      json = { 'donor' => { 'title' => 'Mr', 'first_name' => 'James', 'last_name' => 'Bond', 'address' => {'postcode' => 'N1'} } }
      post "/api/donor", json
      last_response.status.should == 201
      response = JSON.parse last_response.body
      response.except('_id').should == json['donor']
    end
  end
end
