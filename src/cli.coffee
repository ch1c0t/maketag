require '@ch1c0t/io'

global.CWD = process.cwd()
global.SRC = "#{CWD}/src"
global.LIB = "#{CWD}/lib"

{ create } = require './commands/create'
{ build } = require './commands/build'
{ test } = require './commands/test'

exports.run = ->
  [_node, _program, command] = process.argv

  switch command
    when 'new'
      name = process.argv[3]
      create name
    when 'build'
      global.TAG = (require "#{CWD}/package.json").tag
      build()
    when 'test'
      global.TAG = (require "#{CWD}/package.json").tag
      test()
    when 'version'
      { version } = require '../package.json'
      console.log version
    when 'help'
      printHelp()
    else
      printHelp()

printHelp = ->
  console.log """
    A tool to create tags.

      new NAME            Create the directory named NAME and a new project inside of it.
      build               Build the project in the current directory.
      test                Run the tests.
      version             Print the version.
      help                Show this message.
  """
