chokidar = require 'chokidar'

{ build, BuildMain, BuildRest } = require './build'
{ CreateAssetsForManualTesting } = require './watch/assets'

exports.watch = ->
  await build()
  await CreateAssetsForManualTesting()

  watching ["#{SRC}/script.coffee", "#{SRC}/**/*.sass"], BuildMain
  watching ["#{SRC}/**/*.coffee"], BuildRest
  watching ["#{LIB}/**/*.js"], CreateAssetsForManualTesting

watching = (array, fn) ->
  watcher = chokidar.watch array,
    ignoreInitial: yes

  watcher.on 'all', (event, path) ->
    if event in ['add', 'change']
      console.log "#{event} #{path}"
      fn()
