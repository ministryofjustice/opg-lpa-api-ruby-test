require 'spec_helper'

describe Lpa do
  it "should be valid with nil type" do
    Lpa.new().should be_valid
  end
  it "should not be valid with blank type" do
    Lpa.new(:type => "").should be_valid
  end
  it "should be valid with valid type" do
    Lpa.new(:type => "Property and financial affairs").should be_valid
  end
end