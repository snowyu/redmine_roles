ActionController::Routing::Routes.draw do |map|
  map.connect '/:owner_id/:project_id/roles/:action', :controller => "project_role_settings"
  map.connect '/:owner_id/:id/workflow/:action', :controller => 'project_workflow_settings'
  map.with_options :controller => 'my', :condition => {:method => :get} do |my_view|
    my_view.connect 'my/user_guide/:tab', :controller => 'my', :action => 'user_guide'
  end
end
