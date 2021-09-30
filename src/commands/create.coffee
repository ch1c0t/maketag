path = require 'path'

{ CreatePackageFile } = require './create/package'
{ CreateSrc } = require './create/src'
{ CreateJasmineSetup } = require './create/jasmine'
{ CreateIgnoringFiles } = require './create/ignoring'

CWD = process.cwd()
global.ROOT = path.dirname path.dirname __dirname

exports.create = (name) ->
  global.DIR = "#{CWD}/#{name}"

  if IO.exist DIR
    console.error "#{DIR} already exists."
    process.exit 1
  else
    await IO.mkdir DIR

  await CreatePackageFile { name }
  await CreateSrc { name, directory: "#{DIR}/src" }
  await CreateJasmineSetup { name, directory: "#{DIR}/spec" }
  await CreateIgnoringFiles()

  { sh } = require '@ch1c0t/sh'
  await sh 'npm install', cwd: DIR
  await sh 'npm run build', cwd: DIR
