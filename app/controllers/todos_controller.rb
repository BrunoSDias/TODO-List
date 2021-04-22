# frozen_string_literal: true

class TodosController < ApplicationController
  before_action :authenticate_user

  rescue_from ActiveRecord::RecordNotFound do
    render_json(404, todo: { id: 'not found' })
  end

  def index
    json = TodosService.new.list_all(user: current_user, params: params)
    render_json(200, todos: json)
  end

  def create
    todo = TodosService.new.create_todo(user: current_user, params: params)

    if todo.valid?
      render_json(201, todo: todo.serialize_as_json)
    else
      render_json(422, todo: todo.errors.as_json)
    end
  end

  def show
    todo = TodosService.new.find_todo(user: current_user, params: params)
    render_json(200, todo: todo.serialize_as_json)
  end

  def destroy
    todo = TodosService.new.destroy_todo(user: current_user, params: params)
    render_json(200, todo: todo.serialize_as_json)
  end

  def update
    todo = TodosService.new.update_todo(user: current_user, params: params)
    if todo.valid?
      render_json(200, todo: todo.serialize_as_json)
    else
      render_json(422, todo: todo.errors.as_json)
    end
  end

  def complete
    todo = TodosService.new.complete_todo(user: current_user, params: params)

    render_json(200, todo: todo.serialize_as_json)
  end

  def uncomplete
    todo = TodosService.new.uncomplete_todo(user: current_user, params: params)

    render_json(200, todo: todo.serialize_as_json)
  end

  private

    def todo_params
      params.require(:todo).permit(:title, :due_at)
    end
end
