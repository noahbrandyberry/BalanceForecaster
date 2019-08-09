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

  context 'occurrences' do
    it "returns correct daily occurences" do
      item = items(:daily_recurring)
      expect(item.occurrences_between("2019-08-01".to_date.."2019-08-31".to_date)).to eq(["2019-08-29".to_date, "2019-08-30".to_date, "2019-08-31".to_date])
    end

    it "returns correct biweekly occurences" do
      item = items(:biweekly_recurring)
      expect(item.occurrences_between("2019-08-01".to_date.."2019-08-31".to_date)).to eq(["2019-08-02".to_date, "2019-08-16".to_date, "2019-08-30".to_date])
    end

    it "returns correct monthly occurences" do
      item = items(:monthly_recurring)
      expect(item.occurrences_between("2019-08-01".to_date.."2019-08-31".to_date)).to eq(["2019-08-24".to_date])
    end

    it "returns single occurrence when non recurring" do
      item = items(:single)
      expect(item.occurrences_between("2019-08-01".to_date.."2019-08-31".to_date)).to eq(["2019-08-20".to_date])
    end

    it "returns correct occurences with end date" do
      item = items(:daily_recurring)
      expect(item.occurrences_between("2019-10-01".to_date.."2019-10-31".to_date)).to eq(["2019-10-01".to_date, "2019-10-02".to_date])
    end
  end
end
