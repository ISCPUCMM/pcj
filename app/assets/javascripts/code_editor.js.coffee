$(document).on('ready page:load',  () ->


  # editor = ace.edit("editor");
  # editor.setTheme("ace/theme/tomorrow_night");
  # editor.session.setMode("ace/mode/c_cpp");
  # hidden_text = $('textarea[name="problem[code]"]')
  # editor.getSession().on('change', () ->
  #   hidden_text.val(editor.getSession().getValue())
  # )

  $('.code-group').each( (idx) ->
    editor_id = $(@).find('.code-editor').attr('id')
    hidden_text = $(@).find('.mapping-hidden-text-area')
    editor = ace.edit(editor_id)
    editor.setTheme('ace/theme/tomorrow_night')
    editor.getSession().on('change', () ->
      hidden_text.val(editor.getSession().getValue())
    )
  )
)

  # .code-group
  # .code-editor
  # .mapping-hidden-text-area
