CreateSrc = ({ name, directory }) ->
  await IO.mkdir "#{DIR}/src"

  { tag } = require "#{DIR}/package.json"
  global.TAG = tag

  CreateStyle()
  CreateSource()

CreateSource = ->
  TagLine = switch TAG.type
    when 'named'
      "tag '#{TAG.name}',"
    when 'nameless'
      "tag"
    else
      console.error "Unknown TAG.type: #{TAG.type}."

  source = """
    import 'web.tags'

    { div } = TAGS

    #{TagLine}
      data:
        name: -> @value
      view: ->
        div "Hello, \#{@name}."
  """

  await IO.write "#{DIR}/src/script.coffee", source

{ hyphenate } = require 'hyphenate.pascalcase'
CreateStyle = ->
  if TAG.type is 'named'
    await IO.write "#{DIR}/src/style.sass", """
      #{hyphenate TAG.name}
        background-color: black
    """

module.exports = { CreateSrc }
