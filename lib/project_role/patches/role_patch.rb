require_dependency 'project'
#require_dependency 'Role'

module ProjectRole
  module Patches
    module RolePatch
      def self.included(base)
        base.extend ClassMethods

        base.class_eval do
          unloadable
          belongs_to :project
          acts_as_list :scope => :project if  (Role.table_exists? and Role.column_names.include?('project_id'))
          named_scope :givable, { :conditions => "builtin <= 0", :order => 'position' }
          
   
          def name
            if project
              super# + '(' + project.name + ')'
            else
              super + '(' + l('label_global') + ')'
            end
          end

          def validate
            super
            remove_name_taken_error!(errors)
          end

          def remove_name_taken_error!(errors)
            errors.each_error do |attribute, error|
              if error.attribute == :name && error.type == :taken && name_unique_for_project?
                errors_hash = errors.instance_variable_get(:@errors)
                if Array == errors_hash[attribute] && errors_hash[attribute].size > 1
                  errors_hash[attribute].delete_at(errors_hash[attribute].index(error))
                else
                  errors_hash.delete(attribute)
                end
              end
            end
          end
          
          # Return true if the role is a project member role
          def member?
            self.builtin <= 0
          end

          def name_unique_for_project?
            match = Role.find_by_name_and_project_id(name, project_id)
            match.nil? or match == self
          end
          
          # Find all the roles that can be given to a project member
          def self.find_all_givable
             roles = find(:all, :conditions => {:builtin => 0, :project_id => nil}, :order => 'position')
             roles << owner
             p roles
             roles
          end
          
          def self.non_member
            non_member_role = with_exclusive_scope(:find => {:conditions => {:builtin => Role::BUILTIN_NON_MEMBER}}) do
              find(:first)
            end
            if non_member_role.nil?
              non_member_role = create(:name => 'Non member', :position => 0) do |role|
                role.builtin = Role::BUILTIN_NON_MEMBER
              end
              raise 'Unable to create the non-member role.' if non_member_role.new_record?
            end
            non_member_role
          end
          
          def self.anonymous
            anonymous_role = with_exclusive_scope(:find => {:conditions => {:builtin => Role::BUILTIN_ANONYMOUS}}) do
              find(:first)
            end
            if anonymous_role.nil?
              anonymous_role = create(:name => 'Anonymous', :position => 0) do |role|
                role.builtin = Role::BUILTIN_ANONYMOUS
              end
              raise 'Unable to create the anonymous role.' if anonymous_role.new_record?
            end
            anonymous_role
          end
          
        end
      end

      module ClassMethods
        BUILTIN_OWNER  = -100
        def owner()
          owner_role =  with_exclusive_scope(:find => {:conditions => {:builtin => BUILTIN_OWNER}}) do
            find(:first)
          end
          if owner_role.nil?
            owner_role = create(:name => 'Owner', :position => 0) do |role|
              role.builtin = BUILTIN_OWNER
            end
            raise 'Unable to create the owner role.' if owner_role.new_record?
          end
          owner_role
        end
        
        def clone_role_to(aProject)
          find(:all, :conditions => {:builtin => 0, :project_id => nil}, :order => 'position').each do |role|
            r = role.clone
            r.project_id = aProject.id
            r.save!
            Workflow.copy(nil, role, nil, r)
          end
        end

        def find_role_by_project(project_id)
          find(:all, :conditions => {:project_id => project_id}, :order => 'position')
        end    
        
      end
    end
  end
end


