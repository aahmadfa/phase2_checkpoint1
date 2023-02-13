class Store < ApplicationRecord
    has_many :assignments
    has_many :employees, through: :assignments

    #Store name
    validates :name, presence:true, type: string, uniqueness: true
    
    #Street
    validates :street,  presence: true, type: string

    #City
    validates :city, presence: true, type: string

    #State
    validates :state, type: string, length: {is:2}, default: "PA", inclusion {in: %w[PA OH WV]}

    #Zip
    validates :zip, type: string, length: {is:5}, format: { with: /\A\d+\z/, message: "only allows numbers" }

    #Phone
    before_validation :normalize_phone_number
    validates :phone, type: string, length: {is:10}, format: { with: /\A\d+\z/ }

    #Active/Inactive
    validates :active, type: boolean, inclusion: { in: [true, false] }

    
    #Scopes
    scope :active, -> { where(active: true) }
    scope :inactive, -> { where(active: false) }
    scope :alphabetical, -> { order(name: :asc) }

    #Methods
    def make_active
        update(active: true)
    end
    
    def make_inactive
        update(active: false)
    end

    def normalize_phone_number
        self.phone = phone.gsub(/\D/, '')
    end