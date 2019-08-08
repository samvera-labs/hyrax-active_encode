# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "hyrax/active_encode/encode_records/show", type: :view do
  before do
    assign(:encode_presenter, Hyrax::ActiveEncode::EncodePresenter.new(FactoryBot.create(:encode_record)))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Running/)
    expect(rendered).to match(/Title/)
  end
end
