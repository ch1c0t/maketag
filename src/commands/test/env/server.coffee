{ AtExit } = require 'hook.at-exit'
{ sleep } = require '@ch1c0t/sleep'
{ spawn } = require 'child_process'

Server = fun
  init:
    path: -> @value
    port: -> @value or 8080
  once: ->
    serve = spawn './node_modules/.bin/serve', ['-p', @port, @path]
    AtExit -> process.kill serve.pid
    sleep 200
  call: (input) ->
    await @once

    switch input
      when 'port'
        @port

module.exports = { Server }
