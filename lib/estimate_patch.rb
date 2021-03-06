require_dependency 'issue'

module Estimate
  module IssuePatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development
        before_save :update_estimated_hours
      end
    end
    
    module InstanceMethods
      # Updates the estimate after checking if it is already in range of the effort category
      def update_estimated_hours
        set_estimate_from_effort
      end

      # Set the estimate from the effort category
      def set_estimate_from_effort
        effort_field_id = CustomField.find_by_name("Effort").id
        values = self.custom_values
        values.each do |x|
          if x.custom_field_id == effort_field_id
            effort = x.value
            unless effort == "" || effort == nil
              self.estimated_hours = Integer( /.*\((\d+)h\)/.match( effort )[1] )
            end
          end
        end
      end  

    end    
  end
end
