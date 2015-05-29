require 'rails_helper'

RSpec.describe "ranks/index", type: :view do
  before(:each) do
    assign(:ranks, [
      Rank.create!(
        :traffic_rank => 1,
        :domain => nil
      ),
      Rank.create!(
        :traffic_rank => 1,
        :domain => nil
      )
    ])
  end

  it "renders a list of ranks" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
