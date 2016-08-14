class CodeEditor
  constructor: (@code_group) ->

  initialize_languages: (editor) ->
    $(@code_group).find('select.code-select').change( () ->
      mode = switch @.value
        when 'c', 'c_plus_plus' then 'c_cpp'
        when 'java' then 'java'
        when 'ruby' then 'ruby'
        when 'python' then 'python'
        else 'plain_text'

      editor.session.setMode("ace/mode/#{mode}")
    )

  initialize_editor: (editor, hidden_text) ->
    editor.setTheme('ace/theme/tomorrow_night')
    editor.setShowPrintMargin(false);
    editor.getSession().on('change', () ->
      hidden_text.val(editor.getSession().getValue())
    )

  initialize: ->
    editor_id = $(@code_group).find('.code-editor').attr('id')
    editor = ace.edit(editor_id)
    hidden_text = $(@code_group).find('.mapping-hidden-text-area textarea')
    @initialize_editor(editor, hidden_text)
    @initialize_languages(editor)

window.CodeEditor = CodeEditor
# $('.code-group.autosave-editor').each( (idx) ->
#   path = $(@).data('autosave_path')
#   editor_id = $(@).find('.code-editor').attr('id')
#   # debugger;
# )
