module ProjectRole
  module Patches
    module WorkflowPatch
      def self.included(base)
        base.extend ClassMethods

        base.class_eval do
          unloadable
          #belongs_to :role
          #acts_as_list :scope => :project_id
        end
      end

      module ClassMethods
        def count_by_project(project_id)
          counts = connection.select_all("SELECT role_id, tracker_id, count(id) AS c FROM #{Workflow.table_name} GROUP BY role_id, tracker_id")
          roles = Role.find(:all, :order => 'builtin, position', :conditions => {:project_id => project_id} )
          trackers = Tracker.find(:all, :order => 'position')
          result = []
          trackers.each do |tracker|
            t = []
            roles.each do |role|
              row = counts.detect {|c| c['role_id'].to_s == role.id.to_s && c['tracker_id'].to_s == tracker.id.to_s && role.project_id == project_id }
            t << [role, (row.nil? ? 0 : row['c'].to_i)]
            end
            result << [tracker, t]
          end
          result
        end
      end
    end
  end
end

