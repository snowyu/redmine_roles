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
          end

          def step_1
          end
        end
      end

      module ClassMethods
        def step_2
          p url_for(:action => :user_guide, :tab => :step_3)
          redirect_to :action => :user_guide, :tab => :step_3
        end

        def step_3
        end
      end
    end
  end
end
