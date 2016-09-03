class Site < ActiveRecord::Base
    has_many :zones, dependent: :destroy
    def total_spaces
        count = 0
        self.zones.each do |z|
            count += z.total_spaces
        end
        return count
    end
    def used_spaces
        count = 0
        self.zones.each do |z|
            count += z.used_spaces
        end
        return count
    end
end