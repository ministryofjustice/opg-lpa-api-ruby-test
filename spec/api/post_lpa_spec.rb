require 'spec_helper'

describe Opg::API do
  include Rack::Test::Methods

  def app
    Opg::API
  end

  describe 'POST lpa including donor with missing field' do
    it "should return 422 error" do
      json = { 'type' => 'health', 'donor' => { 'title' => 'Mr', 'first_name' => 'James' } }
      post '/api/lpas', json
      last_response.status.should == 422
      response = JSON.parse last_response.body
      response.should == {'errors' =>
        { 'donor' =>
          { 'last_name'=>["can't be blank", 'is too short (minimum is 2 characters)'] }
        }
      }
    end
  end

  describe 'POST lpa including donor with blank field' do
    it "should return 422 error" do
      json = { 'type' => 'health', 'donor' => { 'title' => 'Mr', 'first_name' => 'James', 'last_name' => '' } }
      post '/api/lpas', json
      last_response.status.should == 422
      response = JSON.parse last_response.body
      response.should == {"errors"=>{"donor"=> {"last_name"=>["can't be blank", "is too short (minimum is 2 characters)"]}} }
    end
  end

  describe "POST lpa including donor title, name, and address postcode" do
    it 'should return 200 with JSON' do
      json = {
        'type' => 'health',
        'donor' => {
          'title' => 'Mr',
          'first_name' => 'James',
          'last_name' => 'Bond',
          'address' => { 'post_code' => 'N1' }
        }
      }
      post '/api/lpas', json
      last_response.status.should == 201
      response = JSON.parse last_response.body
      response['donor'].delete('_id')
      response.except('_id').should == json.merge("attorneys"=>[])
      response['_id'].should_not be_nil
    end
  end

  describe 'POST lpa including donor with unknown field' do
    it 'should return 422 error' do
      json = { 'type' => 'health', 'donor' => { first: 'x' } }
      post '/api/lpas', json
      last_response.status.should == 422
      response = JSON.parse last_response.body
      response.should == {"errors" => {"unknown_attribute"=>["Attempted to set a value for 'first' which is not allowed on the model Donor."]}}
    end
  end


end
