{ AtExit } = require 'hook.at-exit'
puppeteer = require 'puppeteer'

Browser = fun
  init:
    headless: -> @value or no
  once: ->
    browser = await puppeteer.launch
      headless: @headless
      args: [
        '--no-sandbox'
        '--disable-setuid-sandbox'
      ]
    AtExit -> browser.close()
    @page = await browser.newPage()
  call: (input) ->
    await @once

    switch input
      when 'page'
        @page

module.exports = { Browser }
