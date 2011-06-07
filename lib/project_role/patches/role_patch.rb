module ProjectRole
  module Patches
    module RolePatch
      def self.included(base)
        base.extend ClassMethods

        base.class_eval do
          unloadable
          belongs_to :project

          def validate
            super
            remove_name_taken_error!(errors)
          end

          def remove_name_taken_error!(errors)
            errors.each_error do |attribute, error|
              if error.attribute == :name && error.type == :taken && name_unique_for_account?
                errors_hash = errors.instance_variable_get(:@errors)
                if Array == errors_hash[attribute] && errors_hash[attribute].size > 1
                  errors_hash[attribute].delete_at(errors_hash[attribute].index(error))
                else
                  errors_hash.delete(attribute)
                end
              end
            end
          end

          def name_unique_for_account?
            match = project.roles.find_by_name(name)
            match.nil? or match == self
          end
        end
      end

      module ClassMethods
        def clone_role_to(aProject)
          find(:all, :conditions => {:project_id => nil}, :order => 'position').each do |role|
            r = role.clone
            r.project_id = aProject.id
            r.save!
            Workflow.copy(nil, role, nil, r)
          end
        end
      end
    end
  end
end