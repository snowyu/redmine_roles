module ProjectRole
  module Patches
    module WorkflowsControllerPatch
      def self.included(base)
        base.class_eval do
          unloadable
          skip_filter :require_admin

        end
      end
    end
  end
end