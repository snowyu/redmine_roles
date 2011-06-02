require 'redmine'

Redmine::Plugin.register :teamkit_project_roles do
  name 'Redmine Teamkit Project Roles plugin'
  author 'Teamkit Dev: Riceball LEE, ZhuangBiaoWei'
  description 'This is a project roles plugin for Redmine'
  version '0.0.1'
  url 'http://www.teamhost.org/projects/tk-prj-roles'
  author_url 'http://www.teamhost.org/about'

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
  require_dependency 'roles_controller'
  RolesController.send(:include, ProjectRole::Patches::RolesControllerPatch)
  require_dependency 'role'
  Role.send(:include, ProjectRole::Patches::RolePatch)
  require_dependency 'project'
  Project.send(:include, ProjectRole::Patches::ProjectPatch)
end