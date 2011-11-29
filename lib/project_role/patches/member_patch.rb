module ProjectRole
  module Patches
    module MemberPatch
      def self.included base
        base.class_eval do
          unloadable
          alias_method :_update_attributes, :update_attributes unless method_defined? :_update_attributes
          
          def update_attributes(columns)
            is_owner = !member_roles.detect{|mr| mr.role == Role.owner}.nil?
            columns[:role_ids] << Role.owner.id if !User.current.admin? and !columns[:role_ids].nil? and is_owner
            is_follower = !member_roles.detect{|mr| mr.role == Role.follower}.nil?
            columns[:role_ids] << Role.follower.id if !columns[:role_ids].nil? and is_follower
            _update_attributes(columns)
          end

          def deletable?
            member_roles.detect {|mr| mr.inherited_from or (mr.role.builtin < 0 and !User.current.admin?)}.nil?
          end

        end # base.class_eval
      end # self.included
    end
  end
end
