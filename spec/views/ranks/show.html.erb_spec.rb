require 'rails_helper'

RSpec.describe "ranks/show", type: :view do
  before(:each) do
    @rank = assign(:rank, Rank.create!(
      :traffic_rank => 1,
      :domain => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(//)
  end
end
