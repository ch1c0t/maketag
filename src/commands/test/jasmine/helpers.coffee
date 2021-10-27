require 'coffeescript/register'

{ CreateAssets } = require '../assets'
{ Env } = require '../env'

CreateENV = ->
  path = await CreateAssets()
  global.ENV = Env
    server: { path }

promise = CreateENV()

global.SetupPage = (fn) ->
  beforeEach ->
    await promise
    @page = await ENV 'page'
    await @page.reload()
    await @page.evaluate fn
    await @page.evaluate ->
      document.body.render ROOT
