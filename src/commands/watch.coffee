chokidar = require 'chokidar'

{ build, BuildMain, BuildRest } = require './build'
{ CreateAssetsForManualTesting } = require './watch/assets'
{ StartServer } = require './watch/server'

exports.watch = ->
  await build()
  path = await CreateAssetsForManualTesting()

  watching ["#{SRC}/script.coffee", "#{SRC}/**/*.sass"], BuildMain
  watching ["#{SRC}/**/*.coffee"], BuildRest
  watching ["#{LIB}/**/*.js"], CreateAssetsForManualTesting

  StartServer { path }

watching = (array, fn) ->
  watcher = chokidar.watch array,
    ignoreInitial: yes

  watcher.on 'all', (event, path) ->
    if event in ['add', 'change']
      console.log "#{event} #{path}"
      fn()
