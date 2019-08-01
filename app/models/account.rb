class Account < ApplicationRecord
    belongs_to :user
    has_many :items
    
    validates :user, presence: true
    validates :name, presence: true
    validates :balance, presence: true
end
