# frozen_string_literal: true

require "rails_helper"

RSpec.describe Hyrax::ActiveEncode::EncodeRecordsController, type: :routing do
  routes { Hyrax::ActiveEncode::Engine.routes }

  describe "routing" do
    it "routes to #index" do
      expect(get: "/encode_records").to route_to(controller: "hyrax/active_encode/encode_records", action: "index")
    end

    it "routes to #show" do
      expect(get: "/encode_records/1").to route_to(controller: "hyrax/active_encode/encode_records", action: "show", id: "1")
    end
  end
end
