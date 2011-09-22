ActionController::Routing::Routes.draw do |map|
  map.connect '/projects/:project_id/roles/:action', :controller => "project_role_settings"
  map.with_options :controller => 'my', :condition => {:method => :get} do |my_view|
    my_view.connect 'my/user_guide/:tab', :controller => 'my', :action => 'user_guide'
  end
end
