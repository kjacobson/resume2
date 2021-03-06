require 'spec_helper'

describe "links/edit" do
  before(:each) do
    @link = assign(:link, stub_model(Link,
      :url => "MyString",
      :user_id => 1,
      :resume_id => 1
    ))
  end

  it "renders the edit link form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => links_path(@link), :method => "post" do
      assert_select "input#link_url", :name => "link[url]"
      assert_select "input#link_user_id", :name => "link[user_id]"
      assert_select "input#link_resume_id", :name => "link[resume_id]"
    end
  end
end
