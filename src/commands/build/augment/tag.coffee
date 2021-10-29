{ UpdateTAG } = require './tag/package'

exports.AugmentTag = (lines) ->
  line = UpdateFirstLineOfLastExpression lines
  UpdateTAG line

UpdateFirstLineOfLastExpression = (lines) ->
  TagLineIndex = lines.reverse().findIndex (line) ->
    not line.startsWith ' '
  TagLine = lines[TagLineIndex]

  lines[TagLineIndex] = "BareTag = #{TagLine}"
  lines.reverse()

  TagLine
