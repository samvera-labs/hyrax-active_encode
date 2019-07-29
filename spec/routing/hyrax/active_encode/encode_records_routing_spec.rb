# frozen_string_literal: true

require "rails_helper"

RSpec.describe Hyrax::ActiveEncode::EncodeRecordController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/encode_record").to route_to("hyrax/active_encode/encode_record#index")
    end

    it "routes to #show" do
      expect(get: "/encode_record/1").to route_to("hyrax/active_encode/encode_record#show", id: "1")
    end
  end
end
