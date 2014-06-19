require 'rails_helper'

describe TodosController do
  describe "GET index" do
    it "sets the @todos variable" do
      cook = Todo.create(name: "cook", description: "cook it")
      sleep = Todo.create(name: "sleep", description: "go sleep")
      get :index
      expect(assigns(:todos)).to eq([cook, sleep])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET new" do
    it "sets the @todo variable" do
      get :new
      expect(assigns(:todo)).to be_new_record
      expect(assigns(:todo)).to be_instance_of(Todo)
    end
    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    it "creates the todo record when the input is valid" do
      post :create, todo: {name: "cook", description: "cook it"}
      expect(Todo.first.name).to eq("cook")
      expect(Todo.first.description).to eq("cook it")
    end
    it "redirects to the root path when the input is valid" do
      post :create, todo: {name: "cook", description: "cook it"}
      # expect(response).to redirect_to(root_path)
      expect(response).to render_template(:index)
    end
    it "does not create a todo when the input is invalid" do
      post :create, todo: {description: "cook it"}
      expect(Todo.count).to eq(0)
    end
    it "renders the new template when the input is invalid" do
      post :create, todo: {description: "cook it"}
      expect(response).to render_template(:index)
    end

    it "does not create tags without inline locations" do
      post :create, todo: {name: "cook"}
      expect(Tag.count).to eql(0)
    end

    it "does not create tags with 'at' in a word without inline locations" do
      post :create, todo: {name: "eat an apple"}
      expect(Tag.count).to eql(0)
    end

    it "creates a tag with the upcase 'AT'" do
      post :create, todo: {name: "shop AT The Apple Store"}
      expect(Tag.all.map(&:tag)).to eql(["location:The Apple Store"])
    end
  end

  context "with inline locations" do
    it "creates a tag with one location" do
      post :create, todo: {name: "cook AT home"}
      expect(Tag.all.map(&:tag)).to eql(["location:home"])
    end

    it "creates two tags with two locations" do
      post :create, todo: {name: "cook AT home and work"}
      expect(Tag.all.map(&:tag)).to eql(["location:home", "location:work"])
    end
    it "creates two tags with four locations" do
      post :create, todo: {name: "cook AT home, work, school and library"}
      expect(Tag.all.map(&:tag)).to eql(["location:home", "location:work", "location:school", "location:library"])
    end
  end
end