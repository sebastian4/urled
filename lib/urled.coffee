UrledView = require './urled-view'
{CompositeDisposable} = require 'atom'

module.exports = Urled =

  activate: ->
    atom.workspaceView.command "urled:encode", => @encode()
    atom.workspaceView.command "urled:decode", => @decode()
    atom.workspaceView.command "urled:decodeJson", => @decodeJson()

  encode: ->

    editor = atom.workspace.activePaneItem
    selection = editor.getSelection()

    urlencode = require 'urlencode2'

    response = selection.getText()

    parts = response.split("?")

    if typeof(parts[1]) == "undefined"

      selection.insertText(response)

    else

      part2encoded = urlencode(parts[1]).replace(/%26/g,"&").replace(/%3D/g,"=").replace(/%23/,"#")

      selection.insertText([parts[0],part2encoded].join("?"))

  decode: ->

    editor = atom.workspace.activePaneItem
    selection = editor.getSelection()

    urlencode = require 'urlencode2'

    response = urlencode.decode(selection.getText())

    selection.insertText(response)

  decodeJson: ->

    editor = atom.workspace.activePaneItem
    selection = editor.getSelection()

    urlencode = require 'urlencode2'
    isJSON = require 'is-json'

    decoded = urlencode.decode(selection.getText())

    selection.insertText(decoded+'\n')

    decoded2 = decoded.split("?")

    decoded21 = decoded2[1]

    if typeof decoded21 isnt 'undefined'

      paramsJson = {}

      params = decoded21.split("&")
      for param in params

        paramCouple = param.split("=")

        if isJSON(paramCouple[1])
          paramsJson[paramCouple[0]] = JSON.parse(paramCouple[1])
        else
          paramsJson[paramCouple[0]] = paramCouple[1]

      selection.insertText(JSON.stringify(paramsJson, null, 4))
