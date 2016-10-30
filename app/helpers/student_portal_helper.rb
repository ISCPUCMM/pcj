module StudentPortalHelper
  def status_class_for(problem_status)
    case problem_status.status
    when 'pending'
      'alert-info'
    when 'accepted'
      'alert-success'
    when 'wa', 'tle'
      'alert-danger'
    when 'error'
      'alert-warning'
    else
      ''
    end
  end
end
