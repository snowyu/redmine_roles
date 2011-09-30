module ProjectRole
  module Patches
    module RolesControllerPatch
      def self.included(base)
        base.class_eval do
          unloadable
          around_filter :apply_scope

          def apply_scope
            @project = find_project_by_project_id #if params[:project_id] and params[:action] != 'new' #just workaround
            Role.send(:with_scope, :find => {:conditions => {:project_id => (@project.nil? or params[:action] == 'new') ? nil : @project.id}}) do
              yield
            end
          end
        end
      end
    end
  end
end
