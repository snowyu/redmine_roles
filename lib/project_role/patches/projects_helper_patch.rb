module ProjectRole
  module Patches
    module ProjectsHelperPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable
          alias_method_chain :project_settings_tabs, :project_role
        end
      end

      module InstanceMethods
        def project_settings_tabs_with_project_role
          tabs = project_settings_tabs_without_project_role
          action = {:name => 'project_role', :controller => 'project_role_settings', :action => :edit, :partial => 'project_role_settings/edit', :label => :project_role}
          tabs << action if User.current.allowed_to?(action, @project)
          action = {:name => 'project_workflow', :controller => 'project_workflow_settings', :action => :edit, :partial => 'project_workflow_settings/edit', :label => :project_workflow}
          tabs << action if User.current.allowed_to?(action, @project)

          tabs
        end
      end
    end
  end
end