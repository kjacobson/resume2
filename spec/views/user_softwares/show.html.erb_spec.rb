require 'spec_helper'

describe "user_softwares/show" do
  before(:each) do
    @user_software = assign(:user_software, stub_model(UserSoftware,
      :user_id => 1,
      :software_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
