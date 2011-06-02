module ProjectRole
  module Patches
    module RolesControllerPatch
      def self.included(base)
        base.class_eval do
          before_filter :apply_scope, :only => [:index, :report]

          def apply_scope
            Role.send(:default_scope, :conditions => {:project_id => nil})
          end
        end
      end
    end
  end
end