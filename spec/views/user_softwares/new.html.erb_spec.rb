require 'spec_helper'

describe "user_softwares/new" do
  before(:each) do
    assign(:user_software, stub_model(UserSoftware,
      :user_id => 1,
      :software_id => 1
    ).as_new_record)
  end

  it "renders new user_software form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => user_softwares_path, :method => "post" do
      assert_select "input#user_software_user_id", :name => "user_software[user_id]"
      assert_select "input#user_software_software_id", :name => "user_software[software_id]"
    end
  end
end
