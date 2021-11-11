{ compile } = require 'coffeescript'

Body = (content) ->
  compile(content, ast: yes).program.body

IsItCallWith = ({ it, name }) ->
  (it.type is 'ExpressionStatement') and
    (it.expression?.type is 'CallExpression') and
    (it.expression?.callee?.name is name)

FindProperties = (body) ->
  try
    describe = body.find (element) ->
      IsItCallWith { name: 'describe', it: element }

    DescribeFunction = describe.expression.arguments[1]
    throw DescribeFunction if DescribeFunction.type isnt 'FunctionExpression'

    block = DescribeFunction.body
    throw block if block.type isnt 'BlockStatement'

    SetupPage = block.body.find (element) ->
      IsItCallWith { name: 'SetupPage', it: element }

    object = SetupPage.expression.arguments[0]
    throw object if object.type isnt 'ObjectExpression'

    root: object.properties.find (property) ->
      property.key.name is 'root'
    script: object.properties.find (property) ->
      property.key.name is 'script'
  catch error
    console.error error
    {}

Config = ({ content, properties }) ->
  lines = content.split "\n"
  { root, script } = properties

  root = if root?
    { start, end } = root.loc
    lines[start.line..end.line-1].join "\n"

  script = if script?
    { start, end } = script.loc
    lines[start.line..end.line-1].join "\n"

  { root, script }

exports.PreparePage = (pathname) ->
  path = "#{CWD}/spec#{pathname}.spec.coffee"
  stub = "The definition of a root element was not found in #{path}."

  IO
    .read path
    .then (content) ->
      config = Config {
        content
        properties: (FindProperties Body content)
      }

      root = config.root ? "p '#{stub}'"
      script = config.script ? "document.body.render ROOT"

      source = """
        window.ROOT = #{root}

        window.SCRIPT = =>
        #{script}
        
        SCRIPT()
      """

      """
        <!DOCTYPE html>
        <html>
          <head>
            <title>To test a page from spec#{pathname}.spec.coffee</title>
            <meta charset="utf-8">
            <meta http-equiv="x-ua-compatible" content="ie=edge">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
          </head>
          <body>
            <script src="/main.js"></script>
            <script>#{compile source}</script>
          </body
        </html>
      """
