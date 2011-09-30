module ProjectRole
  module Patches
    module MyControllerPatch
      def self.included(base)
        base.extend ClassMethods
        
        base.class_eval do
          unloadable
          include MyHelper

          def user_guide
            @projects = Project.latest
            @users = User.all
            @project = Project.new(params[:project])
          end

          def project_create
            @issue_custom_fields = IssueCustomField.find(:all, :order => "#{CustomField.table_name}.position")
            @trackers = Tracker.all
            @project = Project.new
            @project.safe_attributes = params[:project]
            if @project.save
              flash[:notice] = l(:notice_successful_create)
              redirect_to :action => :user_guide, :tab => :step_2
            else
              @projects = Project.latest
              @users = User.all
              render :action => :user_guide
            end
          end
        end
      end

      module ClassMethods
      end
    end
  end
end
