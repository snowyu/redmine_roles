module ProjectRole
  module Patches
    module ProjectPatch
      def self.included base
        base.class_eval do
          unloadable
          has_many :roles
          after_create   :clone_roles

          private
          def clone_roles()
            Role.clone_role_to(self)
          end
        end
      end
    end
  end
end

