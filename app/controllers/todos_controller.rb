class TodosController < ApplicationController
  def index
    @todos = Todo.all
    @todo = Todo.new
  end

  def new
    @todo = Todo.new
  end

  def create
    @todo = Todo.new(todo_params)
    if @todo.save_with_tags
      redirect_to root_path
    else
      @todos = Todo.all
      render :index
    end
  end

  def todo_params
    params.require(:todo).permit(:name, :description)
  end
end
