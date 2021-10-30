exports.Tag = (tag) ->
  new Proxy tag,
    set: (target, key, value) ->
      OldValue = target[key]
      if OldValue isnt value
        target[key] = value
        UpdatePackage target
  
UpdatePackage = (tag) ->
  spec = require "#{CWD}/package.json"
  spec.tag = tag

  console.log "Updating the tag field in package.json."
  json = JSON.stringify spec, null, 2
  IO.write "#{CWD}/package.json", json
