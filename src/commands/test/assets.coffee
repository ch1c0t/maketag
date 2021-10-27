exports.CreateAssets = ->
  dir = '/tmp/maketag/assets'
  await IO.ensure dir

  unless IO.exist "#{dir}/index.hmtl"
    await CreateIndexHTML dir

  await CreateMainJS dir

  dir

CreateIndexHTML = (dir) ->
  html = """
    <!DOCTYPE html>
    <html>
      <head>
        <title>A page to test tags made with maketag</title>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
      </head>
      <body>
        <script src="/main.js"></script>
      </body
    </html>
  """
  IO.write "#{dir}/index.html", html

{ build } = require 'esbuild'
coffee = require 'coffeescript'
CreateMainJS = (dir) ->
  entry = switch TAG.type
    when 'named'
      """
      import "#{CWD}"
      window.#{TAG.name} = TAGS.#{TAG.name}
      """
    when 'nameless'
      """
      import { #{TAG.name} } from "#{CWD}"
      window.#{TAG.name} = #{TAG.name}
      """

  await IO.write "#{dir}/entry.js", (coffee.compile entry)

  build
    entryPoints: ["#{dir}/entry.js"]
    bundle: yes
    outfile: "#{dir}/main.js"
