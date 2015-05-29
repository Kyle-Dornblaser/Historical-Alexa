require 'rails_helper'

RSpec.describe "domains/index", type: :view do
  before(:each) do
    assign(:domains, [
      Domain.create!(
        :name => "Name"
      ),
      Domain.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of domains" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
