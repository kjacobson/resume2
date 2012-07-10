require 'spec_helper'

describe "user_skills/show" do
  before(:each) do
    @user_skill = assign(:user_skill, stub_model(UserSkill,
      :user_id => 1,
      :skill_id => 1
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
