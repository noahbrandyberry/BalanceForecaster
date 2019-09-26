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

  context 'forecast' do
    it "returns correct daily occurences" do
      account = accounts(:checking)
      daily_recurring = items(:daily_recurring)
      biweekly_recurring = items(:biweekly_recurring)
      monthly_recurring = items(:monthly_recurring)
      single = items(:single)
      forecast_item = forecast_items(:biweekly_recurring_occurrence)

      expect(account.forecast("2019-08-01".to_date.."2019-08-31".to_date).map(&:source)).to eq([
        Occurrence.new(biweekly_recurring, "2019-08-02".to_date),
        Occurrence.new(biweekly_recurring, "2019-08-17".to_date, biweekly_recurring.name, 25),
        Occurrence.new(single, "2019-08-20".to_date),
        Occurrence.new(monthly_recurring, "2019-08-24".to_date),
        Occurrence.new(daily_recurring, "2019-08-29".to_date, daily_recurring.name, 10),
        Occurrence.new(daily_recurring, "2019-08-30".to_date, daily_recurring.name, 10),
        Occurrence.new(biweekly_recurring, "2019-08-30".to_date),
        Occurrence.new(daily_recurring, "2019-08-31".to_date, daily_recurring.name, 10)
      ].map(&:source))
    end
  end

  context 'balance_before' do
    it "returns correct balance on occurrence start date" do
      account = accounts(:checking)
      daily_recurring = items(:daily_recurring)
      biweekly_recurring = items(:biweekly_recurring)

      expect(account.balance_before(Occurrence.new(biweekly_recurring, "2019-08-30".to_date))).to eq(-105)
    end
  end
end
