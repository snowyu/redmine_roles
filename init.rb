require 'redmine'

Redmine::Plugin.register :teamkit_project_roles do
  name 'Redmine Teamkit Project Roles plugin'
  author 'Teamkit Dev: Riceball LEE, ZhuangBiaoWei'
  description 'This is a project roles plugin for Redmine'
  version '0.0.2'
  url 'https://github.com/snowyu/redmine_roles'

  #the permissions will be put in the Project permission.
  #permission :project_role_setting, {:project_role_settings => [:show, :update, :add_filter, :edit_filter, :sort]}, :require => :member
  permission :project_workflow_setting, {:project_workflow_settings => [:index, :edit, :copy]}, :require => :member
  permission :project_role_setting, {:project_role_settings => [:index, :new, :edit, :destroy, :copy]}, :require => :member
=begin
  project_module :project_role do
    permission :project_workflow_setting, {:project_workflow_settings => [:index, :edit, :copy]}, :require => :member
    permission :project_role_setting, {:project_role_settings => [:show, :update, :add_filter, :edit_filter, :sort]}, :require => :member
  end
=end
end

require 'dispatcher'
Dispatcher.to_prepare :teamkit_project_roles do
  require_dependency 'workflow'
  Workflow.send(:include, ProjectRole::Patches::WorkflowPatch)
  require_dependency 'roles_controller'
  RolesController.send(:include, ProjectRole::Patches::RolesControllerPatch)
  require_dependency 'member'
  Member.send(:include, ProjectRole::Patches::MemberPatch)
  require_dependency 'role'
  Role.send(:include, ProjectRole::Patches::RolePatch)
  require_dependency 'project'
  Project.send(:include, ProjectRole::Patches::ProjectPatch)
  require_dependency 'projects_helper'
  unless ProjectsHelper.included_modules.include? ProjectRole::Patches::ProjectsHelperPatch
    ProjectsHelper.send(:include, ProjectRole::Patches::ProjectsHelperPatch)
  end
  require_dependency 'my_helper'
  MyHelper.send(:include, ProjectRole::Patches::MyHelperPatch)
  require_dependency 'my_controller'
  MyController.send(:include, ProjectRole::Patches::MyControllerPatch)
end

ActionView::Base.send :include,ProjectRole::Patches::MyHelperPatch
