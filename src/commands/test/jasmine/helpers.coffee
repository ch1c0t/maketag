require 'coffeescript/register'

{ CreateAssets } = require '../assets'
{ Env } = require '../env'

CreateENV = ->
  path = await CreateAssets()
  global.ENV = Env
    server: { path }

promise = CreateENV()

global.SetupPage = ({ root }) ->
  beforeEach ->
    await promise
    @page = await ENV 'page'
    await @page.reload()

    if root?
      handle = await @page.evaluateHandle root
      await handle.evaluate (root) ->
        window.ROOT = root

    await @page.evaluate ->
      document.body.render ROOT
