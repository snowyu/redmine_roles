require_dependency 'projects_helper'

module ProjectRoleHelperPatch

  def self.included(base) # :nodoc:
    base.send(:include, ProjectsHelperMethods)

    base.class_eval do
      #unloadable

      alias_method_chain :project_settings_tabs, :project_role
    end

  end
end


module ProjectsHelperMethods
  def project_settings_tabs_with_project_role
    tabs = project_settings_tabs_without_project_role
    action = {:name => 'project_role', :controller => 'project_role_settings', :action => :edit, :partial => 'project_role_settings/edit', :label => :project_role}
    tabs << action if User.current.allowed_to?(action, @project)

    tabs
  end
end

ProjectsHelper.send(:include, ProjectRoleHelperPatch)