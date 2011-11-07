module ProjectRole
  module Patches
    module WorkflowsControllerPatch
      def self.included(base)
        base.class_eval do
          unloadable
          skip_filter :require_admin
          before_filter :authorize_global, :only =>[:edit,:copy]

        end
      end
    end
  end
end