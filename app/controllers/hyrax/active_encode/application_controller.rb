# frozen_string_literal: true
module Hyrax
  module ActiveEncode
    class ApplicationController < Hyrax::MyController
      protect_from_forgery with: :exception
    end
  end
end
