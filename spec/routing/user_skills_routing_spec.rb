require "spec_helper"

describe UserSkillsController do
  describe "routing" do

    it "routes to #index" do
      get("/user_skills").should route_to("user_skills#index")
    end

    it "routes to #new" do
      get("/user_skills/new").should route_to("user_skills#new")
    end

    it "routes to #show" do
      get("/user_skills/1").should route_to("user_skills#show", :id => "1")
    end

    it "routes to #edit" do
      get("/user_skills/1/edit").should route_to("user_skills#edit", :id => "1")
    end

    it "routes to #create" do
      post("/user_skills").should route_to("user_skills#create")
    end

    it "routes to #update" do
      put("/user_skills/1").should route_to("user_skills#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/user_skills/1").should route_to("user_skills#destroy", :id => "1")
    end

  end
end
