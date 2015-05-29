require 'rails_helper'

RSpec.describe "ranks/new", type: :view do
  before(:each) do
    assign(:rank, Rank.new(
      :traffic_rank => 1,
      :domain => nil
    ))
  end

  it "renders new rank form" do
    render

    assert_select "form[action=?][method=?]", ranks_path, "post" do

      assert_select "input#rank_traffic_rank[name=?]", "rank[traffic_rank]"

      assert_select "input#rank_domain_id[name=?]", "rank[domain_id]"
    end
  end
end
