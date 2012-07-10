require 'spec_helper'

describe "user_skills/new" do
  before(:each) do
    assign(:user_skill, stub_model(UserSkill,
      :user_id => 1,
      :skill_id => 1
    ).as_new_record)
  end

  it "renders new user_skill form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => user_skills_path, :method => "post" do
      assert_select "input#user_skill_user_id", :name => "user_skill[user_id]"
      assert_select "input#user_skill_skill_id", :name => "user_skill[skill_id]"
    end
  end
end
