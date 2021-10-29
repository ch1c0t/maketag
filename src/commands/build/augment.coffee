{ UpdateTAG } = require './augment/tag'
{ AddStyle } = require './augment/style'

exports.AugmentSource = (source) ->
  lines = AddBareTag source
  AddTAG lines

  if TAG.type is 'named'
    lines.push "window.TAGS.#{TAG.name} = TAG"

  lines.push "export { TAG as #{TAG.name} }"
  lines.join "\n"

AddBareTag = (source) ->
  index = UpdateTAG source
  lines = source.split "\n"
  lines[index] = "BareTag = #{lines[index]}"
  lines

AddTAG = (lines) ->
  if IO.exist "#{SRC}/style.sass"
    AddStyle lines
  else
    lines.push "TAG = BareTag"
