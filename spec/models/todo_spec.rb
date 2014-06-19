require 'rails_helper'

describe Todo do
  it { should validate_presence_of(:name)}

  describe "#name_only?" do
    it "returns true if the description is nil" do
      todo = Todo.new(name: "cooking")
      expect(todo).to be_name_only
    end
    it "returns true if the description is an empty string" do
      todo = Todo.new(name: "cooking", description: "")
      expect(todo).to be_name_only
    end
    it "returns false if the description is a non empty string" do
      todo = Todo.new(name: "cooking", description: "cook it")
      expect(todo).not_to be_name_only
    end
  end

  describe "#display_text" do
    let(:todo) {Todo.create(name: "cook dinner")}
    # let(:todo) {Fabricate.build(:todo)}
    subject { todo.display_text }

    context "no tags" do
      it {expect(subject).to eq("cook dinner")}
    end

    context "one tag" do
      before {todo.tags.create(tag: "home")} 
      it {expect(subject).to eq("cook dinner (tag: home)")}
    end

    context "multiple tags" do
      before do
        todo.tags.create(tag: "home") 
        todo.tags.create(tag: "urgent") 
      end
      it {expect(subject).to eq("cook dinner (tags: home, urgent)")}
    end

    context "more than four tags" do
      before do
        todo.tags.create(tag: "home") 
        todo.tags.create(tag: "urgent") 
        todo.tags.create(tag: "hunger") 
        todo.tags.create(tag: "steak") 
        todo.tags.create(tag: "broccoli") 
      end
      it {expect(subject).to eq("cook dinner (tags: home, urgent, hunger, steak, more...)")}
    end
  end

  describe "search_by_name" do
    let(:cook) {cook = Todo.create(name: "cooking", description: "love to cook", created_at: 1.day.ago)}
    let(:ride) {ride = Todo.create(name: "riding", description: "love to ride")}
    it "retruns an empty array if there is no match" do
      expect(Todo.search_by_name("fart")).to eq([])
    end
    it "returns an array of one todo for an exact match" do
      expect(Todo.search_by_name("riding")).to eq([ride])
    end
    it "returns an array of one todo for a partial match" do
      expect(Todo.search_by_name("oo")).to eq([cook])
    end
    it "returns an array of all matches ordered by created_at" do
      expect(Todo.search_by_name("ing")).to eq([ride, cook])
    end
    it "returns an empty array for a search with an empty string" do
      expect(Todo.search_by_name("")).to eq([])
    end
  end
end