# Patch the redmine model: Role
module RoleEx

  def self.included(base) # :nodoc:
    base.class_eval do
      unloadable
      belongs_to :project
      before_validation   :on_before_validation
      
      private
      def on_before_validation()
        self.name += '(' + self.project.identifier + ')' if self.project and not self.name.blank? and self.name[-1,1] != ')'
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

  def name_with_global()
    if project
      name
    else
      name + '(' + l('label_global') + ')'
    end
  end

  def name_with_project()
    #if project
    #  name + '(' + project.name + ')'
    #else
    name + '(' + l('label_global') + ')' unless project
    #end
  end

  def project_name()
    if project
      project.name
    else
      l('label_global')
    end
  end
end

Role.send(:include, RoleEx)

module ProjectRole
    module MixinProject
      def self.included base
        base.class_eval do
          after_create   :clone_roles

          private
          def clone_roles()
             Role.clone_role_to(self)
          end
        end
      end
    end
end
Project.send :include, ProjectRole::MixinProject

