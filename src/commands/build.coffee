coffee = require 'coffeescript'

exports.build = ->
  file = "#{SRC}/script.coffee"
  unless IO.exist file
    console.error "#{file} does not exist."
    process.exit 1

  await IO.ensure LIB 

  source = await IO.read file
  source = AugmentSource source
  output = coffee.compile source

  await IO.write "#{LIB}/main.js", output

AugmentSource = (source) ->
  lines = source.split "\n"

  TagLineIndex = lines.reverse().findIndex (line) ->
    line.startsWith 'tag'
  lines[TagLineIndex] = "BareTag = #{lines[TagLineIndex]}"
  lines.reverse()

  if IO.exist "#{SRC}/style.sass"
    CompileStyles()
    lines.push """
      import { css } from './css.js'
      HeadCSS = ->
        unless document.getElementById '#{TAG.name}'
          { style } = TAGS
          s = style id: '#{TAG.name}'
          s.textContent = css
          head = document.querySelector 'head'
          head.appendChild s
      TAG = (...args) ->
        HeadCSS()
        BareTag ...args
    """
  else
    lines.push "TAG = BareTag"

  lines.push "export { TAG as #{TAG.name} }"
  lines.join "\n"

sass = require 'sass'
CompileStyles = ->
  result = sass.renderSync file: "#{SRC}/style.sass"
  output = coffee.compile """
    css = "#{result.css.toString()}"

    export { css }
  """
  IO.write "#{LIB}/css.js", output
