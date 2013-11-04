require 'spec_helper'

describe Donor do

  let(:person_json) do
    { title: 'Mr', first_name: 'James', last_name: 'Bond', 'address' => { 'post_code' => 'N1' } }
  end

  context 'without date_of_birth' do
    it 'should not be valid' do
      Donor.new(person_json).should_not be_valid
    end
  end

  context 'with badly formatted date_of_birth' do
    it 'should not be valid' do
      donor = Donor.new(person_json.merge('date_of_birth'=>'xyz'))
      donor.valid?
      donor.date_of_birth.should == nil
      donor.should_not be_valid
    end
  end

  context 'with date_of_birth' do
    it 'should be valid' do
      Donor.new(person_json.merge('date_of_birth'=>'2013-01-01')).should be_valid
    end
  end
end