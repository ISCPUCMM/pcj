$(document).on('ready page:load',  () ->
  $('.code-group').each( (idx) ->
    editor_id = $(@).find('.code-editor').attr('id')
    hidden_text = $(@).find('.mapping-hidden-text-area textarea')
    editor = ace.edit(editor_id)
    editor.setTheme('ace/theme/tomorrow_night')
    editor.getSession().on('change', () ->
      hidden_text.val(editor.getSession().getValue())
    )

    $(@).find('select.code-select').change( () ->
      mode = switch @.value
        when 'c', 'c_plus_plus' then 'c_cpp'
        when 'ruby' then 'ruby'
        when 'python' then 'python'
        else 'plain_text'

      editor.session.setMode("ace/mode/#{mode}")
    )
  )
)
