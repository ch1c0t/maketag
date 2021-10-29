exports.UpdatePackage = ->
  spec = require "#{CWD}/package.json"

  if (spec.tag.name is TAG.name) and (spec.tag.type is TAG.type)
    return
  else
    console.log "Updating the tag field in package.json."
    spec.tag = TAG
    json = JSON.stringify spec, null, 2
    IO.write "#{CWD}/package.json", json
