{ AugmentTag } = require './augment/tag'
{ AugmentStyle } = require './augment/style'

exports.AugmentSource = (source) ->
  lines = source.split "\n"
  AugmentTag lines

  if IO.exist "#{SRC}/style.sass"
    AugmentStyle lines
  else
    lines.push "TAG = BareTag"

  if TAG.type is 'named'
    lines.push "window.TAGS.#{TAG.name} = TAG"

  lines.push "export { TAG as #{TAG.name} }"
  lines.join "\n"
