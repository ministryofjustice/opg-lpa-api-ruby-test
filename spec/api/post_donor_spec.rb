require 'spec_helper'

describe Lpa::API do
  include Rack::Test::Methods

  def app
    Lpa::API
  end

  describe 'POST donor with missing field' do
    it "should return 422 error" do
      json = { 'title' => 'Mr', 'first_name' => 'James' }
      post '/api/donors', json
      last_response.status.should == 422
      response = JSON.parse last_response.body
      response.should == {"errors"=>{"last_name"=>["can't be blank", "is too short (minimum is 2 characters)"]}}
    end
  end

  describe 'POST donor with blank field' do
    it "should return 422 error" do
      json = { 'title' => 'Mr', 'first_name' => 'James', 'last_name' => '' }
      post '/api/donors', json
      last_response.status.should == 422
      response = JSON.parse last_response.body
      response.should == {"errors"=>{"last_name"=>["can't be blank", "is too short (minimum is 2 characters)"]}}
    end
  end

  describe "POST donor title, name, and address postcode" do
    it 'should return 200 with JSON' do
      json = { 'title' => 'Mr', 'first_name' => 'James', 'last_name' => 'Bond', 'address' => {'postcode' => 'N1'} }
      post '/api/donors', json
      last_response.status.should == 201
      response = JSON.parse last_response.body
      response.except('_id').should == json
      response['_id'].should_not be_nil
    end
  end

  describe 'POST donor with unknow field' do
    it 'should return 422 error' do
      json = { first: 'x' }
      post '/api/donors', json
      last_response.status.should == 422
      response = JSON.parse last_response.body
      response.should == {"errors" => {"unknown_attribute"=>["Attempted to set a value for 'first' which is not allowed on the model Donor."]}}
    end
  end


end
