require 'redmine'
require File.dirname(__FILE__) + '/lib/project_roles_member_patch.rb'
require File.dirname(__FILE__) + '/lib/project_roles_workflow_helper_patch.rb'
require File.dirname(__FILE__) + '/lib/project_role_helper_patch.rb'

Redmine::Plugin.register :teamkit_project_roles do
  name 'Redmine Teamkit Project Roles plugin'
  author 'Teamkit Dev: Riceball LEE, ZhuangBiaoWei'
  description 'This is a project roles plugin for Redmine'
  version '0.0.1'
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
