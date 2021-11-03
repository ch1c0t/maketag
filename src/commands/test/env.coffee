{ fun } = require '@ch1c0t/fun'
{ as } = require 'value.as'

global.fun = fun
global.as = as

{ Server } = require './env/server'
{ Browser } = require './env/browser'

Env = fun
  init:
    server: as Server
    browser: as Browser
  once: ->
    port = await @server 'port'
    @page = await @browser 'page'
    @url = "http://localhost:#{port}"
    await @page.goto @url
  call: (input) ->
    try
      await @once

      switch input
        when 'page'
          @page
        when 'NewPage'
          page = await @browser 'NewPage'
          await page.goto @url
          page
    catch error
      console.log error

module.exports = { Env }
