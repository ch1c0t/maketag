chokidar = require 'chokidar'

{ build, BuildMain, BuildRest } = require './build'
{ CreateAssets } = require './test/assets'

exports.watch = ->
  await build()
  await CreateAssets()

  watching ["#{SRC}/script.coffee", "#{SRC}/**/*.sass"], BuildMain
  watching ["#{SRC}/**/*.coffee"], BuildRest
  watching ["#{LIB}/**"], CreateAssets

watching = (array, fn) ->
  watcher = chokidar.watch array,
    ignoreInitial: yes

  watcher.on 'all', (event, path) ->
    if event in ['add', 'change']
      console.log "#{event} #{path}"
      fn()
