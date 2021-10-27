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
    await @page.goto "http://localhost:#{port}"
  call: (input) ->
    try
      await @once

      switch input
        when 'page'
          @page
    catch error
      console.log error

module.exports = { Env }
