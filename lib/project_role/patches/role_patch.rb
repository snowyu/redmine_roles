module ProjectRole
  module Patches
    module RolePatch
      def self.included(base)
        base.class_eval do
          belongs_to :project

          def before_validation
            self.name = self.name + self.project_id.to_i.to_s
          end

          def after_validation
            self.name = self.name.gsub(/#{self.project_id.to_i}$/, '')
          end
        end

        base.extend ClassMethods
      end

      module ClassMethods
        # Define class methods here.
        # Find all the roles that can be given to a project member
        def get_by_project(aProjectId)
          find(:all, :conditions => {:builtin => 0, :project_id => aProjectId}, :order => 'position')
        end

        def clone_role_to(aProject)
          roles = find(:all, :conditions => {:project_id => nil, :builtin => 0}, :order => 'position')
          roles.each do |role|
            r = find(:first, :conditions => {:name => role.name, :project_id => aProject.id})
            if not r
              r = role.clone
              r.project_id = aProject.id
              #r.name += '(' + aProject.identifier + ')'
              #r.builtin = 0 if r.builtin != 0
              r.save!
            end
            Workflow.copy(nil, role, nil, r)
          end #each roles
        end
      end
    end
  end
end