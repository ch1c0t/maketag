exports.UpdateTAG = (line) ->
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

  UpdatePackage()

IsTagNamed = (line) ->
  (line.startsWith 'tag "') or (line.startsWith "tag '")

IsTagNameless = (line) ->
  line.startsWith 'tag'

IsTagWrapped = (line) ->
  (line.startsWith '(') or (line.startsWith '->')

TagNameFromLine = (line) ->
  line[5..].split(/'|"/)[0]

UpdatePackage = ->
  spec = require "#{CWD}/package.json"

  if (spec.tag.name is TAG.name) and (spec.tag.type is TAG.type)
    return
  else
    console.log "Updating the tag field in package.json."
    spec.tag = TAG
    json = JSON.stringify spec, null, 2
    IO.write "#{CWD}/package.json", json
