require 'spec_helper'
require_relative '../api/shared_lpa_setup'

describe Lpa do

  include_context "shared LPA setup"

  let(:applicant) do
    applicant = Applicant.new applicant_json
    applicant.save
    applicant
  end

  it "should be valid with nil type" do
    Lpa.new(applicant_id: applicant.id).should be_valid
  end

  it "should not be valid with blank type" do
    Lpa.new(applicant_id: applicant.id, :type => "").should be_valid
  end

  it "should be valid with valid type" do
    Lpa.new(applicant_id: applicant.id, :type => "Property and financial affairs").should be_valid
  end

  describe 'deleting attorney' do
    let(:applicant_id) do
      attorney = Applicant.create(applicant_json)
      attorney.id
    end

    it 'should delete attorney' do
      lpa = Lpa.create(lpa_json)
      lpa.update_attributes(attorneys: [ attorney_json ])
      lpa.attorneys.size.should == 1

      lpa = Lpa.find(lpa.id)
      lpa.attorneys.size.should == 1
      id = lpa.attorneys.first.id

      lpa.update_attributes(attorneys_attributes: [ { id: id, _destroy: true } ])
      lpa.attorneys.size.should == 0
      lpa = Lpa.find(lpa.id)
      lpa.attorneys.size.should == 0
    end
  end
end