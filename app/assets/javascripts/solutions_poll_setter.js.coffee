class SolutionsPollSetter
  constructor: () ->
    @timeout = null
    @form = '#student_solutions'
    @user_change_action()
    @form_submission_success()

  user_change_action: ->
    $(@form).find('#student_portal_problem_solutions_user_id').on('change', =>
      clearTimeout @timeout
      @submit_form(@form)
    )

  submit_form: (form) ->
    $(form).submit()

  form_submission_success: ->
    $(@form).on('ajax:success', (e, data, status, xhr) =>
      @timeout = setTimeout(@submit_form, 5000, @form)

      $(JSON.parse(xhr.responseText)).each( ->
        $("#problem_text_#{@.problem_id}").val(@.code)
        $("#problem_text_#{@.problem_id}").trigger('change')
      )
    ).on 'ajax:error', (e, xhr, status, error) ->

window.SolutionsPollSetter = SolutionsPollSetter
