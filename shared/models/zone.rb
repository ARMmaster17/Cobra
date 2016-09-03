class Zone < ActiveRecord::Base
    has_many :lots, dependent: :destroy
    belongs_to :sites
    def total_spaces
        count = 0
        self.lots.each do |l|
            count += l.total_spaces
        end
        return count
    end
    def used_spaces
        count = 0
        self.lots.each do |l|
            count += l.used_spaces
        end
        return count
    end
end