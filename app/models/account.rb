class Account < ApplicationRecord
    belongs_to :user
    has_many :items
    
    validates :user, presence: true
    validates :name, presence: true
    validates :balance, presence: true

    def available_transfer_accounts
        user.accounts.where.not(id: id)
    end

    def to_s
        name
    end
end
