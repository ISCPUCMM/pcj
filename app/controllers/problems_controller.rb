class ProblemsController < ApplicationController
  before_action :logged_in_user
  before_action :check_problem_ownership, except: [:index, :new, :create, :polygon_create]
  before_action :check_input_files_uploaded, only: [:generate_outputs]

  def index
    @problems = Problem.owned_by(current_user)
  end

  def show
    @problem = Problem.find(params[:id])
    redirect_to(edit_problem_path(@problem))
  end

  def new
    @problem = Problem.new
  end

  def edit
    @problem = Problem.find(params[:id])
  end

  def preview
    @problem = Problem.find(params[:id])
  end

  def group_test_cases
    @problem = Problem.find(params[:id])
    test_group = TestGroup.new(problem: @problem)
    problem_params[:test_cases_attributes].values.select { |v| v[:selected] == '1' }
      .map { |v| TestCase.find(v[:id]) }.each do |tc|
        test_group.test_cases << tc
      end

    test_group.save! unless test_group.test_cases.empty?

    redirect_to(edit_problem_path(@problem, anchor: 'output_gen'))
  end

  def group_individual_test_cases
    @problem = Problem.find(params[:id])

    @problem.test_cases.ungrouped.each do |tc|
      test_group = TestGroup.new(problem: @problem)
      test_group.test_cases << tc
      test_group.save!
    end

    redirect_to(edit_problem_path(@problem, anchor: 'output_gen'))
  end

  def ungroup_test_cases
    @problem = Problem.find(params[:id])
    test_group = @problem.test_groups.find_by(id: params[:group_id])

    if test_group.present?
      test_group.test_cases.update_all(test_group_id: nil)
      test_group.destroy
      flash[:success] = 'Ungrouping successful'
    else
      flash[:danger] = 'There was an error ungrouping'
    end

    redirect_to(edit_problem_path(@problem, anchor: 'output_gen'))
  end

  def upload_input_files
    @problem = Problem.find(params[:id])
    flash[:success] = 'Input files uploaded successfully' if @problem.upload_input_files(upload_input_files_params)
    redirect_to :back
  end

  def generate_outputs
    @problem = Problem.find(params[:id])
    if @problem.generate_outputs(generate_outputs_params)
      flash[:success] = 'Generation of output enqueued, reload page in a minute to view status.'
    else
      flash[:danger] = 'Unable to generate output with provided options.'
    end

    redirect_to(edit_problem_path(@problem, anchor: 'output_gen'))
  end

  def create
    @problem = Problem.new(problem_params.merge(owner: current_user))
    if @problem.save
      flash[:info] = 'Problem created successfully'
      redirect_to edit_problem_path(@problem)
    else
      render 'new'
    end
  end

  def update
    @problem = Problem.find(params[:id])
    redirect_params = {}
    redirect_params[:anchor] = params[:anchor] if params[:anchor].present?

    if @problem.update_attributes(problem_params)
      flash[:success] = 'Problem updated successfully'
      redirect_to edit_problem_path(@problem, redirect_params)
    else
      flash[:danger] = 'There was an error updating the problem'
      render 'edit'
    end
  end

  def polygon_create
    flash[:success] = 'Your polygon zip was uploaded and is processing your problem' if Problem.polygon_create(upload_polygon_params.merge(owner: current_user))
    redirect_to :back
  end

  private  def problem_params
    params.require(:problem).permit(:name, :statement, :input_format, :output_format, :examples, :notes, :time_limit, test_cases_attributes: [:id, :selected], test_groups_attributes: [:weight, :id])
  end

  private  def upload_input_files_params
    params.require(:problem).permit(:input_files)
  end

  private  def upload_polygon_params
    params.require(:problem).permit(:polygon_files)
  end

  private def generate_outputs_params
    params.require(:problem).permit(:code, :language)
  end

  private def check_problem_ownership
    if current_user?(Problem.find(params[:id]).owner)
      true
    else
      flash[:danger] = "You do not have access to view page"
      redirect_to(root_url)
    end
  end

  private def check_input_files_uploaded
    if (problem = Problem.find(params[:id])).input_files_uploaded_at?
      true
    else
      flash[:danger] = 'You must upload input files before generating an output'
      redirect_to(edit_problem_path(problem))
    end
  end
end
