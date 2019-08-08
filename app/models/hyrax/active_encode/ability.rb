# frozen_string_literal: true
module Hyrax
  module ActiveEncode
    module Ability
      extend ActiveSupport::Concern

      included do
        self.ability_logic += [:encode_dashboard_permissions]
      end

      def encode_dashboard_permissions
        can :read, :encode_dashboard if admin?
      end
    end
  end
end
