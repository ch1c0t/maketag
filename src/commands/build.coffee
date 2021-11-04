coffee = require 'coffeescript'
{ AugmentSource } = require './build/augment'
{ BuildRest } = require './build/rest'

build = ->
  await IO.ensure LIB
  BuildMain()
  BuildRest()

BuildMain = ->
  file = "#{SRC}/script.coffee"
  unless IO.exist file
    console.error "#{file} does not exist."
    process.exit 1

  source = await IO.read file
  source = AugmentSource source
  output = coffee.compile source

  await IO.write "#{LIB}/main.js", output

module.exports = { build, BuildMain, BuildRest }
