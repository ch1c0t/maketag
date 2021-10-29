exports.AugmentTag = (lines) ->
  line = UpdateFirstLineOfLastExpression lines
  UpdateTAG line

UpdateTAG = (line) ->
  if IsTagNamed line
    TAG.type = 'named'
    TAG.name = TagNameFromLine line
  else if IsTagNameless line
    TAG.type = 'nameless'
  else if IsTagWrapped line
    TAG.type = 'wrapped'
  else
    console.error """
      The last expression in "#{SRC}/script.coffee" must be a tag.
      The following line doesn't seem to be a beginning of a tag:

      #{line}
    """

IsTagNamed = (line) ->
  (line.startsWith 'tag "') or (line.startsWith "tag '")

IsTagNameless = (line) ->
  line.startsWith 'tag'

IsTagWrapped = (line) ->
  (line.startsWith '(') or (line.startsWith '->')

TagNameFromLine = (line) ->
  line[5..].split(/'|"/)[0]

UpdateFirstLineOfLastExpression = (lines) ->
  TagLineIndex = lines.reverse().findIndex (line) ->
    not line.startsWith ' '
  TagLine = lines[TagLineIndex]

  lines[TagLineIndex] = "BareTag = #{TagLine}"
  lines.reverse()

  TagLine
