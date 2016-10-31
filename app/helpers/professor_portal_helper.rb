module ProfessorPortalHelper
  def student_work_so_far_dropdown_for(course)
    course.users.order(:name).map { |user| [ user.name_with_email, user.id ] }
  end

  def color_map(stat)
    {
      'no_status' => '#cfd2d6',
      'pending' => '#507aba',
      'accepted' => '#30a046',
      'wa' => '#ff0505',
      'tle' => '#e88888',
      'error' => '#ff7905'
    }[stat]
  end

  def pie_chart_solution_stats_for(course:, assignment:, problem:)
    rows = StudentPortal::ProblemSolution.stats_for(course: course, assignment: assignment, problem: problem)

    {
      title: "Final Results for #{problem.name}",
      rows: rows.to_a,
      colors: rows.keys.map { |stat| color_map(stat) }
    }
  end

  def pie_chart_submission_stats_for(course:, assignment:, problem:)
    rows = StudentPortal::Submission.stats_for(course: course, assignment: assignment, problem: problem)

    {
      title: "All Submissions for #{problem.name}",
      rows: rows.to_a,
      colors: rows.keys.map { |stat| color_map(stat) }
    }
  end
end
