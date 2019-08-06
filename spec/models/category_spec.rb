require 'rails_helper'

RSpec.describe Category, type: :model do
  fixtures :all
  
  context 'before creation' do
    it 'must have a name' do
      user = users(:noah)
      expect { Category.create!(name: nil, user: user) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'has a name that is too long' do
      user = users(:noah)
      expect { Category.create!(name: (str = "0" * 999999), user: user) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'must belong to a user' do
      expect { Category.create!(name: 'Gas', user: nil) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "is valid with valid attributes" do
      user = users(:noah)
      expect(Category.new(name: 'Gas', user: user)).to be_valid
    end
  end
end
