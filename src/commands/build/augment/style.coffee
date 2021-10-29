coffee = require 'coffeescript'
sass = require 'sass'

CompileStyles = ->
  result = sass.renderSync file: "#{SRC}/style.sass"
  output = coffee.compile """
    css = "#{result.css.toString()}"

    export { css }
  """
  IO.write "#{LIB}/css.js", output

exports.AddStyle = (lines) ->
  CompileStyles()
  lines.push """
    import { css } from './css.js'
    HeadCSS = ->
      id = '#{TAG.name}Style'
      unless document.getElementById id
        { style } = TAGS
        s = style { id }
        s.textContent = css
        head = document.querySelector 'head'
        head.appendChild s
    TAG = (...args) ->
      HeadCSS()
      BareTag ...args
  """
