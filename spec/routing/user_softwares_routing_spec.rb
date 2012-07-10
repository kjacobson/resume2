require "spec_helper"

describe UserSoftwaresController do
  describe "routing" do

    it "routes to #index" do
      get("/user_softwares").should route_to("user_softwares#index")
    end

    it "routes to #new" do
      get("/user_softwares/new").should route_to("user_softwares#new")
    end

    it "routes to #show" do
      get("/user_softwares/1").should route_to("user_softwares#show", :id => "1")
    end

    it "routes to #edit" do
      get("/user_softwares/1/edit").should route_to("user_softwares#edit", :id => "1")
    end

    it "routes to #create" do
      post("/user_softwares").should route_to("user_softwares#create")
    end

    it "routes to #update" do
      put("/user_softwares/1").should route_to("user_softwares#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/user_softwares/1").should route_to("user_softwares#destroy", :id => "1")
    end

  end
end
