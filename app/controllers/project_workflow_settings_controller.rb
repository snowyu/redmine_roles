class ProjectWorkflowSettingsController < WorkflowsController 
  unloadable
  layout 'base'
 
  prepend_before_filter :find_project
  before_filter :authorize, :find_roles
  before_filter :find_trackers

  def index
    @workflow_counts = Workflow.count_by_project(@project.id)
  end
  
  private

  def find_roles
    @roles = Role.find_role_by_project(@project.id)
  end

  def find_trackers
    @trackers = Tracker.find(:all, :order => 'position')
  end
end
