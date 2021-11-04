coffee = require 'coffeescript'
glob = require 'glob'
path = require 'path'

BuildRest = ->
  files = glob.sync "#{SRC}/**/*.coffee", nodir: yes

  for file in files
    unless file is "#{SRC}/script.coffee"
      await BuildFile file

BuildFile = (file) ->
  source = await IO.read file
  output = coffee.compile source

  target = (file.replace SRC, LIB)[..-7] + 'js' # without .coffee
  await IO.ensure path.dirname target
  await IO.write target, output

module.exports = { BuildRest, BuildFile }
