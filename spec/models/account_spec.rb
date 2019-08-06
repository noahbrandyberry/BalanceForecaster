require 'rails_helper'

RSpec.describe Account, type: :model do
  fixtures :all

  context 'before creation' do
    subject { described_class.new }

    it "is valid with valid attributes" do
      subject.name = "Shell Gas Purchase"
      subject.balance = 0
      subject.user = users(:noah)
      expect(subject).to be_valid
    end

    it "is not valid without a name" do
      expect(subject).to_not be_valid
    end
  
    it "is not valid without a balance" do
      subject.name = "Checking"
      expect(subject).to_not be_valid
    end
  
    it "is not valid without a user" do
      subject.name = "Checking"
      subject.balance = 0
      expect(subject).to_not be_valid
    end
  end
end
