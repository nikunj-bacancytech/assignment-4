class User < ApplicationRecord
    acts_as_paranoid
    has_many :addresses, :dependent => :destroy
    accepts_nested_attributes_for :addresses, reject_if: :all_blank, allow_destroy: true

    validates :name, presence: true

    enum status: { active: 'Active', inactive: 'Inactive' }
    enum gender: { male: 'Male', female: 'Female', other: 'Other' }

    def self.generate
        
    end

    def self.pick_one
        self.order(Arel.sql('RANDOM()')).first
    end
end
