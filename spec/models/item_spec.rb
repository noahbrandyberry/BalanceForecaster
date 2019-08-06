require 'rails_helper'

RSpec.describe Item, type: :model do
  fixtures :all

  context 'before creation' do
    subject { described_class.new }

    it "is valid with valid attributes" do
      subject.name = "Shell Gas Purchase"
      subject.account = accounts(:checking)
      subject.amount = 10
      subject.start_date = DateTime.now
      expect(subject).to be_valid
    end

    it "is valid with valid attributes when repeating" do
      subject.name = "Shell Gas Purchase"
      subject.account = accounts(:checking)
      subject.amount = 10
      subject.start_date = DateTime.now
      subject.repeat = true
      subject.repeat_frequency = 2
      subject.repeat_type = 'week'
      expect(subject).to be_valid
    end
  
    it "is not valid without a name" do
      expect(subject).to_not be_valid
    end
  
    it "is not valid without an account" do
      subject.name = "Shell Gas Purchase"
      expect(subject).to_not be_valid
    end
  
    it "is not valid without an amount" do
      subject.name = "Shell Gas Purchase"
      subject.account = accounts(:checking)
      expect(subject).to_not be_valid
    end
  
    it "is not valid without a start_date" do
      subject.name = "Shell Gas Purchase"
      subject.account = accounts(:checking)
      subject.amount = 10
      expect(subject).to_not be_valid
    end
  
    it "is not valid without a repeat_frequency when repeating" do
        subject.name = "Shell Gas Purchase"
      subject.account = accounts(:checking)
      subject.amount = 10
      subject.start_date = DateTime.now
      subject.repeat = true
      subject.repeat_frequency = nil
      subject.repeat_type = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a repeat_type when repeating" do
      subject.name = "Shell Gas Purchase"
      subject.account = accounts(:checking)
      subject.amount = 10
      subject.start_date = DateTime.now
      subject.repeat = true
      subject.repeat_frequency = 1
      subject.repeat_type = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without an amount greater than 0" do
      subject.name = "Shell Gas Purchase"
      subject.account = accounts(:checking)
      subject.amount = 0
      subject.start_date = DateTime.now
      expect(subject).to_not be_valid
    end

    it "is not valid without a repeat_frequency greater than 0" do
      subject.name = "Shell Gas Purchase"
      subject.account = accounts(:checking)
      subject.amount = 10
      subject.start_date = DateTime.now
      subject.repeat = true
      subject.repeat_frequency = 0
      subject.repeat_type = 'week'
      expect(subject).to_not be_valid
    end
  end
end
