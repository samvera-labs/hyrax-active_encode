# frozen_string_literal: true
module Hyrax
  module ActiveEncode
    class Engine < ::Rails::Engine
      isolate_namespace Hyrax::ActiveEncode
    end
  end
end
