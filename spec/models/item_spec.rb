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
      expect(item.occurrences_between("2019-08-01".to_date.."2019-08-31".to_date).map(&:source)).to eq([
        Occurrence.new(item, "2019-08-29".to_date, item.name, 10), 
        Occurrence.new(item, "2019-08-30".to_date, item.name, 10), 
        Occurrence.new(item, "2019-08-31".to_date, item.name, 10)
      ].map(&:source))
    end

    it "returns correct biweekly occurences" do
      item = items(:biweekly_recurring)
      forecast_item = forecast_items(:biweekly_recurring_occurrence)
      expect(item.occurrences_between("2019-08-01".to_date.."2019-08-31".to_date).map(&:source)).to eq([
        Occurrence.new(item, "2019-08-02".to_date), 
        Occurrence.new(item, "2019-08-17".to_date, item.name, 25), 
        Occurrence.new(item, "2019-08-30".to_date)
      ].map(&:source))
    end

    it "returns correct monthly occurences" do
      item = items(:monthly_recurring)
      expect(item.occurrences_between("2019-08-01".to_date.."2019-08-31".to_date).map(&:source)).to eq([
        Occurrence.new(item, "2019-08-24".to_date)
      ].map(&:source))
    end

    it "returns single occurrence when non recurring" do
      item = items(:single)
      expect(item.occurrences_between("2019-08-01".to_date.."2019-08-31".to_date).map(&:source)).to eq([
        Occurrence.new(item, "2019-08-20".to_date)
      ].map(&:source))
    end

    it "returns correct occurences with end date" do
      item = items(:daily_recurring)
      expect(item.occurrences_between("2019-10-01".to_date.."2019-10-31".to_date).map(&:source)).to eq([
        Occurrence.new(item, "2019-10-01".to_date, item.name, 10), 
        Occurrence.new(item, "2019-10-02".to_date, item.name, 10)
      ].map(&:source))
    end

    it "returns correct occurences with biweekly end date" do
      item = items(:biweekly_recurring)
      expect(item.occurrences_between("2019-09-01".to_date.."2019-10-31".to_date).map(&:source)).to eq([
        Occurrence.new(item, "2019-09-13".to_date), 
        Occurrence.new(item, "2019-09-27".to_date)
      ].map(&:source))
    end
  end

  context 'first_occurence_after' do
    it "returns correct daily occurrence" do
      item = items(:daily_recurring)
      expect(item.first_occurence_after("2019-08-01".to_date)).to eq("2019-08-29".to_date)
    end

    it "returns correct biweekly occurrence" do
      item = items(:biweekly_recurring)
      expect(item.first_occurence_after("2019-08-01".to_date)).to eq("2019-08-02".to_date)
    end

    it "returns correct monthly occurrence" do
      item = items(:monthly_recurring)
      expect(item.first_occurence_after("2019-08-01".to_date)).to eq("2019-08-24".to_date)
    end

    it "returns single occurrence when non recurring" do
      item = items(:single)
      expect(item.first_occurence_after("2019-08-01".to_date)).to eq("2019-08-20".to_date)
    end

    it "returns correct occurrence before end date" do
      item = items(:daily_recurring)
      expect(item.first_occurence_after("2019-10-01".to_date)).to eq("2019-10-01".to_date)
    end

    it "returns correct occurence on end date" do
      item = items(:daily_recurring)
      expect(item.first_occurence_after("2019-10-02".to_date)).to eq("2019-10-02".to_date)
    end

    it "returns no occurence after end date" do
      item = items(:daily_recurring)
      expect(item.first_occurence_after("2019-10-03".to_date)).to eq(nil)
    end

    it "returns correct occurence after rounding" do
      item = items(:biweekly_recurring)
      expect(item.first_occurence_after("2019-09-20".to_date)).to eq("2019-09-27".to_date)
    end
  end

  context 'last_occurence_before' do
    it "returns no occurrence before start date when recurring" do
      item = items(:daily_recurring)
      expect(item.last_occurence_before("2019-08-01".to_date)).to eq(nil)
    end

    it "returns correct occurrence after start date when recurring" do
      item = items(:daily_recurring)
      expect(item.last_occurence_before("2019-08-31".to_date)).to eq("2019-08-31".to_date)
    end

    it "returns no occurrence before start date when non recurring" do
      item = items(:single)
      expect(item.last_occurence_before("2019-08-01".to_date)).to eq(nil)
    end

    it "returns correct occurrence after start date when non recurring" do
      item = items(:single)
      expect(item.last_occurence_before("2019-09-01".to_date)).to eq("2019-08-20".to_date)
    end

    it "returns correct occurrence before end date" do
      item = items(:daily_recurring)
      expect(item.last_occurence_before("2019-10-01".to_date)).to eq("2019-10-01".to_date)
    end

    it "returns correct occurence on end date" do
      item = items(:daily_recurring)
      expect(item.last_occurence_before("2019-10-02".to_date)).to eq("2019-10-02".to_date)
    end

    it "returns correct occurence after end date" do
      item = items(:daily_recurring)
      expect(item.last_occurence_before("2019-10-03".to_date)).to eq("2019-10-02".to_date)
    end

    it "returns correct occurence after rounding" do
      item = items(:biweekly_recurring)
      expect(item.last_occurence_before("2019-10-03".to_date)).to eq("2019-09-27".to_date)
    end
  end
  
  context 'amount_before' do
    it "returns no amount before start date when recurring" do
      biweekly_recurring = items(:biweekly_recurring)
      item = items(:daily_recurring)
      expect(item.amount_before(Occurrence.new(biweekly_recurring, "2019-08-02".to_date))).to eq(0)
    end

    it "returns correct amount after start date when recurring" do
      biweekly_recurring = items(:biweekly_recurring)
      item = items(:daily_recurring)
      expect(item.amount_before(Occurrence.new(biweekly_recurring, "2019-08-30".to_date))).to eq(-20)
    end

    it "returns no amount before start date when non recurring" do
      biweekly_recurring = items(:biweekly_recurring)
      item = items(:single)
      expect(item.amount_before(Occurrence.new(biweekly_recurring, "2019-08-02".to_date))).to eq(0)
    end

    it "returns correct amount after start date when non recurring" do
      biweekly_recurring = items(:biweekly_recurring)
      item = items(:single)
      expect(item.amount_before(Occurrence.new(biweekly_recurring, "2019-08-30".to_date))).to eq(-10)
    end

    it "returns correct amount before end date" do
      biweekly_recurring = items(:biweekly_recurring)
      item = items(:daily_recurring)
      expect(item.amount_before(Occurrence.new(biweekly_recurring, "2019-09-27".to_date))).to eq(-300)
    end

    it "returns correct amount after end date" do
      biweekly_recurring = items(:biweekly_recurring)
      item = items(:daily_recurring)
      expect(item.amount_before(Occurrence.new(biweekly_recurring, "2019-10-11".to_date))).to eq(-350)
    end

    it "returns correct amount with biweekly recurrence" do
      item = items(:biweekly_recurring)
      expect(item.amount_before(Occurrence.new(item, "2019-09-27".to_date))).to eq(-85)
    end
  end
end
