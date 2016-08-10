module StudentPortal
  class BaseController < ApplicationController
    before_action :logged_in_user

    before_action :load_user
    before_action :correct_user

    private def load_user
      @user = User.find_by_id(params[:user_id]) or not_found
    end

    private def load_course
      @course = Course.find_by_id(params[:course_id]) or not_found
    end

    private def load_course_and_assignment
      course_assignment = CourseAssignment.find_by(course_id: params[:course_id], assignment_id: params[:assignment_id]) or not_found

      @course = course_assignment.course
      @assignment = course_assignment.assignment
    end

    private def correct_user
      if current_user?(@user)
        true
      else
        flash[:danger] = 'You do not have access to view page'
        redirect_to(root_url) and return false
      end
    end

    private def correct_course
      if @course.students.where(id: @user).present?
        true
      else
        unauthorized_access_message_and_redirect_to user_student_portal_courses_path(@user)
      end
    end

    private def correct_course_assignment
      if @course && @assignment
        true
      else
        unauthorized_access_message_and_redirect_to user_student_portal_courses_path(@user)
      end
    end

    private def correct_course
      if @course.students.where(id: @user).present?
        true
      else
        unauthorized_access_message_and_redirect_to user_student_portal_courses_path(@user)
      end
    end

    private def assignment_started?
      if @assignment.starts_at <= DateTime.now
        true
      else
        redirect_to(
          asc_user_student_portal_course_assignment_problems_path(user_id: @user,
                                                                  course_id: @course,
                                                                  assignment_id: @assignment)
          ) and return false
      end
    end
  end
end
