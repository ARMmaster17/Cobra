class Zone < ActiveRecord::Base
    has_many :lots, dependent: :destroy
    belongs_to :sites
end