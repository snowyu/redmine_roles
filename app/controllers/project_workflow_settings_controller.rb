class ProjectWorkflowSettingsController < WorkflowsController 
  unloadable
  layout 'base'
 
  before_filter :find_project, :authorize
  before_filter :find_roles
  before_filter :find_trackers
  
  private

  def find_roles
    @roles = @project.roles
  end
  
  def find_trackers
    @trackers = Tracker.find(:all, :order => 'position')
  end
end
