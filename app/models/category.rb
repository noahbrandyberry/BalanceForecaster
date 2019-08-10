class Category < ApplicationRecord
    belongs_to :user
    has_many :items

    validates :user, presence: true
    validates :name, presence: true, length: { maximum: 100 }, uniqueness: { scope: :user_id }

    def to_s
        name
    end
end
