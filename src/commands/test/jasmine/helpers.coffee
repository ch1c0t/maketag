require 'coffeescript/register'

{ CreateAssetsForAutomatedTesting } = require '../assets'
{ Env } = require '../env'

CreateENV = ->
  path = await CreateAssetsForAutomatedTesting()
  global.ENV = Env
    server: { path }

promise = CreateENV()

global.SetupPage = ({ device, root, script }) ->
  beforeAll ->
    await promise
    @page = await ENV 'NewPage'
    if device?
      puppeteer = require 'puppeteer'
      await @page.emulate puppeteer.devices[device]

  beforeEach ->
    await @page.reload()

    if root?
      @handle = await @page.evaluateHandle root
      await @handle.evaluate (root) ->
        window.ROOT = root

      @root = new Proxy @handle,
        get: (target, key) ->
          target.evaluate "ROOT.#{key}"

    if script?
      await @page.evaluate script
    else
      await @page.evaluate ->
        document.body.render ROOT
