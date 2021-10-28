coffee = require 'coffeescript'
{ AugmentSource } = require './build/augment'

exports.build = ->
  file = "#{SRC}/script.coffee"
  unless IO.exist file
    console.error "#{file} does not exist."
    process.exit 1

  await IO.ensure LIB 

  source = await IO.read file
  source = AugmentSource source
  output = coffee.compile source

  await IO.write "#{LIB}/main.js", output
