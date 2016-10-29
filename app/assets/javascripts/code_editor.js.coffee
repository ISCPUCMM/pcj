class CodeEditor
  constructor: (@code_group) ->
    @editor_id = $(@code_group).find('.code-editor').attr('id')
    @editor = ace.edit(@editor_id)
    @hidden_text = $(@code_group).find('.mapping-hidden-text-area textarea')
    @current_text = @hidden_text.val()

  initialize_languages: ->
    editor = @editor
    $(@code_group).find('select.code-select').change( () ->
      mode = switch @.value
        when 'c', 'c_plus_plus' then 'c_cpp'
        when 'java' then 'java'
        when 'ruby' then 'ruby'
        when 'python' then 'python'
        else 'plain_text'

      editor.session.setMode("ace/mode/#{mode}")
    )
    $(@code_group).find('select.code-select').trigger('change')

  initialize_editor: ->
    @editor.setTheme('ace/theme/tomorrow_night')
    @editor.setShowPrintMargin(false)
    @editor.$blockScrolling = Infinity
    @editor.getSession().setValue(@current_text)
    @editor.getSession().on('change', () =>
      @hidden_text.val(@editor.getSession().getValue())
    )

  set_read_only: ->
    @editor.setReadOnly(true)

  inverse_editor: ->
    @editor.renderer.$cursorLayer.element.style.display = 'none'
    @editor.setHighlightActiveLine(false);

    @set_read_only()
    @hidden_text.on('change', =>
      line_num = (@editor.getFirstVisibleRow()+@editor.getLastVisibleRow())/2 + 1
      @editor.getSession().setValue(@hidden_text.val())
      @editor.gotoLine(line_num);
    )


  initialize_autosave: ->

    set_save_message = (message, class_name) =>
      code_save_msg.text(message)
      code_save_msg.removeClass('saved failed saving')
      code_save_msg.addClass(class_name)

    save_code = =>
      if @editor.getSession().getValue() != @current_text
        @current_text = @editor.getSession().getValue()
        set_save_message('Saving...', 'saving')

        $.ajax({
          url: autosave_path,
          type: 'PATCH',
          data: { 'code': @current_text }
          dataType: 'json'
          timeout: 4000
        }).done(->
          set_save_message('Saved', 'saved')
          return
        ).fail(->
          set_save_message('Failed to save', 'failed')
          return
        ).always(->
          return
        )

    autosave_path = $(@code_group).data('autosave_path')
    code_save_msg = $(@code_group).find('#code_save_msg')
    @editor.on('focus', () =>
      @interval = setInterval(save_code, 5000)
    )
    @editor.on('blur', () =>
      clearInterval(@interval)
      save_code()
    )

  initialize_default: ->
    @initialize_editor()
    @initialize_languages()

window.CodeEditor = CodeEditor
