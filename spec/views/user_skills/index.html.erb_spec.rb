require 'spec_helper'

describe "user_skills/index" do
  before(:each) do
    assign(:user_skills, [
      stub_model(UserSkill,
        :user_id => 1,
        :skill_id => 1
      ),
      stub_model(UserSkill,
        :user_id => 1,
        :skill_id => 1
      )
    ])
  end

  it "renders a list of user_skills" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
