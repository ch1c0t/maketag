require 'coffeescript/register'

{ CreateAssets } = require '../assets'
{ Env } = require '../env'

CreateENV = ->
  path = await CreateAssets()
  global.ENV = Env
    server: { path }

promise = CreateENV()

global.SetupPage = ({ root, device }) ->
  beforeEach ->
    await promise
    @page = await ENV 'page'
    if device?
      puppeteer = require 'puppeteer'
      await @page.emulate puppeteer.devices[device]

    await @page.reload()

    if root?
      @handle = await @page.evaluateHandle root
      await @handle.evaluate (root) ->
        window.ROOT = root

      @root = new Proxy @handle,
        get: (target, key) ->
          target.evaluate "ROOT.#{key}"

    await @page.evaluate ->
      document.body.render ROOT
