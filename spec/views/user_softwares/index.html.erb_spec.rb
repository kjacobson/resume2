require 'spec_helper'

describe "user_softwares/index" do
  before(:each) do
    assign(:user_softwares, [
      stub_model(UserSoftware,
        :user_id => 1,
        :software_id => 1
      ),
      stub_model(UserSoftware,
        :user_id => 1,
        :software_id => 1
      )
    ])
  end

  it "renders a list of user_softwares" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
