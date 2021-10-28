chokidar = require 'chokidar'

{ build } = require './build'
{ CreateAssets } = require './test/assets'

exports.watch = ->
  await build()
  await CreateAssets()

  watching ["#{SRC}/**/*.coffee", "#{SRC}/**/*.sass"], build
  watching ["#{LIB}/**"], CreateAssets

watching = (array, fn) ->
  watcher = chokidar.watch array,
    ignoreInitial: yes

  watcher.on 'all', (event, path) ->
    if event in ['add', 'change']
      console.log "#{event} #{path}"
      fn()
