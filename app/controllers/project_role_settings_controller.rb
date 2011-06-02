# redMine - project management software
# Copyright (C) 2006  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

class ProjectRoleSettingsController < RolesController
 
  unloadable
  layout 'base'
 
  before_filter :find_project, :authorize
  before_filter :appy_role_project, :only => [:new]

  verify :method => :post, :only => [ :destroy, :move ],
         :redirect_to => { :action => :index }

  def appy_role_project
    params[:role] = {:permissions => Role.non_member.permissions, :project_id => @project.id} if params[:role].blank? and not request.post?
  end

  def new
    super
    @roles = Role.find :all,:conditions=>{:project_id=>@project.id}, :order => 'builtin, position'
 
    return
    # Prefills the form with 'Non member' role permissions
    @role = Role.new(params[:role] || {:permissions => Role.non_member.permissions})
    @role.project=@project
    if request.post? && @role.save
      # workflow copy
      if !params[:copy_workflow_from].blank? && (copy_from = Role.find_by_id(params[:copy_workflow_from]))
        @role.workflows.copy(copy_from)
      end
      flash[:notice] = l(:notice_successful_create)
      redirect_to :controller=>'projects', :action => 'settings',:id=>params[:id],:tab=>'project_role'
    end
    @permissions = @role.setable_permissions
    @roles = Role.find :all,:conditions=>{:project_id=>@project.id}, :order => 'builtin, position'
  end

  def edit
    @role = Role.find(params[:role_id])
    if request.post? and @role.update_attributes(params[:role])
      flash[:notice] = l(:notice_successful_update)
      redirect_to :controller=>'projects', :action => 'settings',:id=>params[:id],:tab=>'project_role'
    end
    @permissions = @role.setable_permissions
  end

  def destroy
    @role = Role.find(params[:role_id])
    @role.destroy
    redirect_to :controller=>'projects', :action => 'settings',:id=>params[:id],:tab=>'project_role'
  rescue
    flash[:error] =  l(:error_can_not_remove_role)
    redirect_to :controller=>'projects', :action => 'settings',:id=>params[:id],:tab=>'project_role'
  end 
  #  @role.project=@project
end
