ActionController::Routing::Routes.draw do |map|
  map.connect '/projects/:project_id/roles/:action', :controller => "project_role_settings"
end