module ProjectRole
  module Patches
    module MyHelperPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        #base.extend ClassMethods

        base.class_eval do
          unloadable

        end
      end

      module InstanceMethods
        def user_guide_tabs
          tabs = [{:name => 'step_1', :action => :step_1, :partial => 'my/step_1', :label => :label_step_1},
                  {:name => 'step_2', :action => :step_2, :partial => 'my/step_2', :label => :label_step_2},
                  {:name => 'step_3', :action => :step_3, :partial => 'my/step_3', :label => :label_step_3},
                 ]
        end
      end
    end
  end
end

