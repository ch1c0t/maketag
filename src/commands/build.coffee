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
  TagLine = lines[TagLineIndex]
  lines[TagLineIndex] = "BareTag = #{TagLine}"
  lines.reverse()

  if IsTagNamed TagLine
    TagType = 'named'
    TagName = TagNameFromLine TagLine
  else
    TagType = 'nameless'
    TagName = TAG.name

  if IO.exist "#{SRC}/style.sass"
    CompileStyles()
    lines.push """
      import { css } from './css.js'
      HeadCSS = ->
        id = '#{TagName}Style'
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
  else
    lines.push "TAG = BareTag"

  if TagType is 'named'
    lines.push "window.TAGS.#{TagName} = TAG"

  lines.push "export { TAG as #{TagName} }"
  lines.join "\n"

sass = require 'sass'
CompileStyles = ->
  result = sass.renderSync file: "#{SRC}/style.sass"
  output = coffee.compile """
    css = "#{result.css.toString()}"

    export { css }
  """
  IO.write "#{LIB}/css.js", output

IsTagNamed = (line) ->
  (line.startsWith 'tag "') or (line.startsWith "tag '")

TagNameFromLine = (line) ->
  line[5..].split(/'|"/)[0]
