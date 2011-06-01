require_dependency 'projects_helper'

module ProjectRolesWorkflowHelperPatch

  def self.included(base) # :nodoc:
    base.send(:include, ProjectsHelperMethodsWorkflow)

    base.class_eval do
      #unloadable

      alias_method_chain :project_settings_tabs, :project_workflow
    end

  end
end


module ProjectsHelperMethodsWorkflow
  def project_settings_tabs_with_project_workflow
    tabs = project_settings_tabs_without_project_workflow
    action = {:name => 'project_workflow', :controller => 'project_workflow_settings', :action => :edit, :partial => 'project_workflow_settings/edit', :label => :project_workflow}
    tabs << action if User.current.allowed_to?(action, @project)

    tabs
  end
end

ProjectsHelper.send(:include, ProjectRolesWorkflowHelperPatch)

