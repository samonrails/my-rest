module Status

  module Vendor

    def self.available_values
      %w{active inactive onboarding}
    end

    def self.active
      "active"
    end

    def self.inactive
      "inactive"
    end
    
    def self.onboarding
      "onboarding"
    end
  end

  module Document

    def self.available_values
      %w{generating generated}
    end

    def self.generating
      "generating"
    end

    def self.generated
      "generated"
    end
  end

  module Event

    def self.available_values 
      %w{auto_generated proposed scheduled active in_progress complete final canceled} 
    end

    def self.available_values_for_user 
      %w{proposed scheduled active in_progress complete final canceled} 
    end

    def self.proposed
      "proposed"
    end

    def self.scheduled
      "scheduled"
    end
      
    def self.active
      "active"
    end
      
    def self.in_progress
      "in_progress"
    end
      
    def self.complete
      "complete"
    end
      
    def self.final
      "final"
    end

    def self.canceled
      "canceled"
    end

    def self.auto_generated
      "auto_generated"
    end

    def self.values_for_feedback_email
      %w{active in_progress complete final} 
    end

  end
end
