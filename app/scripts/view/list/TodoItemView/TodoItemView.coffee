define (require, exports, module) ->
  Backbone = require 'backbone'
  require 'backbone.epoxy'
  $ = Backbone.$

  TodoItemView = Backbone.Epoxy.View.extend
    template: $('#todoItem').html()

    className: 'todo-item'

    ui:
      $id: '[data-js-todo-id]'
      $title: '[data-js-todo-title]'
      $done: '[data-js-todo-done]'
      $editTitleInput: '[data-js-todo-edit-title]'
      $buttonDelete: '[data-js-todo-delete]'
      $buttonEdit: '[data-js-todo-edit]'

    events:
      'click [data-js-todo-done]': 'onDoneClick'
      'click [data-js-todo-delete]': 'onDeleteClick'
      'click [data-js-todo-edit]': 'onEditClick'
      'keypress [data-js-todo-edit-title]': 'onEditTitleKeypress'

    bindings:
      '[data-js-todo-id]': "attr: {'data-js-todo-id': id}"
      '[data-js-todo-title]': 'text: title'
      '[data-js-todo-done]': 'checked: done'
      '[data-js-todo-edit-title]': 'value: title'

    initialize: ->
      @$el.html @template
      @render()
      @setUi()
      @listenTo @model, 'change', @render
      @listenTo @model, 'destroy', @remove

    setUi: ->
      ui = {}
      _.each @ui, (element, key)=>
        ui[key] = @$(element)
      @ui = ui

    onEditClick: ->
      @ui.$title.addClass 'hidden'
      @ui.$editTitleInput.removeClass 'hidden'

    onEditTitleKeypress: (e)->
      if (e.keyCode == 13)
        @model.changeTitle @ui.$editTitleInput.val()
        @ui.$title.removeClass 'hidden'
        @ui.$editTitleInput.addClass 'hidden'

    onDoneClick: (e)->
      @model.toggle()

    onDeleteClick: ->
      @model.destroy()

    remove: ->
      @$el.remove()
