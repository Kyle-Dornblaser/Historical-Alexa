require 'rails_helper'

RSpec.describe "ranks/edit", type: :view do
  before(:each) do
    @rank = assign(:rank, Rank.create!(
      :traffic_rank => 1,
      :domain => nil
    ))
  end

  it "renders the edit rank form" do
    render

    assert_select "form[action=?][method=?]", rank_path(@rank), "post" do

      assert_select "input#rank_traffic_rank[name=?]", "rank[traffic_rank]"

      assert_select "input#rank_domain_id[name=?]", "rank[domain_id]"
    end
  end
end
