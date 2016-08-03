class AssignmentsController < ApplicationController
  before_action :logged_in_user
  before_action :check_assignment_ownership, except: [:index, :new, :create]

  def index
    @assignments = Assignment.owned_by(current_user)
  end

  def show
    @assignment = Assignment.find(params[:id])
    redirect_to edit_assignment_path(@assignment)
  end

  def new
    @assignment = Assignment.new
  end

  def create
    @assignment = Assignment.new(assignment_params.merge(owner: current_user))
    if @assignment.save
      flash[:info] = 'Assignment created successfully.'
      redirect_to edit_assignment_path(@assignment)
    else
      render 'new'
    end
  end

  def edit
    @assignment = Assignment.find(params[:id])
  end

  #disables destroy until soft delete added
  # def destroy
  #   Assignment.find(params[:id]).destroy
  #   flash[:success] = 'Assignment deleted'
  #   redirect_to administration_user_path(current_user)
  # end

  def add_problem
    @assignment = Assignment.find(params[:id])
    problem_id = problem_params[:problem]

    if @assignment.add_problem(problem_id)
      flash[:success] = 'Problem added successfully to assignment'
    else
      flash[:warning] = 'Invalid selection'
    end
    redirect_to edit_assignment_path(params[:id])
  end

  def remove_problem
    @assignment = Assignment.find(params[:id])
    problem_id = params[:problem_id]

    if @assignment.remove_problem(problem_id)
      flash[:success] = 'Problem removed successfully from assignment'
    else
      flash[:warning] = 'Something funky happened :)'
    end

    redirect_to edit_assignment_path(params[:id])
  end

  def update
    @assignment = Assignment.find(params[:id])
    if @assignment.update_attributes(assignment_params)
      flash[:success] = 'Assignment updated'
      redirect_to administration_user_path(current_user)
    else
      render 'edit'
    end
  end

  private  def assignment_params
    params.require(:assignment).permit(:name, :starts_at, :ends_at, :description)
  end

  private  def problem_params
    params.require(:assignment).permit(:problem)
  end

  private def check_assignment_ownership
    if current_user?(Assignment.find(params[:id]).owner)
      true
    else
      flash[:danger] = "You do not have access to view page"
      redirect_to(root_url)
    end
  end
end
