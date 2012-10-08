require 'spec_helper'

describe "links/new" do
  before(:each) do
    assign(:link, stub_model(Link,
      :url => "MyString",
      :user_id => 1,
      :resume_id => 1
    ).as_new_record)
  end

  it "renders new link form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => links_path, :method => "post" do
      assert_select "input#link_url", :name => "link[url]"
      assert_select "input#link_user_id", :name => "link[user_id]"
      assert_select "input#link_resume_id", :name => "link[resume_id]"
    end
  end
end
