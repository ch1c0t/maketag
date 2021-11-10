exports.CreateAssets = ({ dir, CreateIndexHTML })->
  await IO.ensure dir

  unless IO.exist "#{dir}/index.hmtl"
    await CreateIndexHTML dir

  await CreateMainJS dir

  dir

{ build } = require 'esbuild'
{ compile } = require 'coffeescript'

CreateMainJS = (dir) ->
  entry = """
    import { #{TAG.name} } from "#{CWD}"
    window.#{TAG.name} = #{TAG.name}
  """

  await IO.write "#{dir}/entry.js", (compile entry)

  build
    entryPoints: ["#{dir}/entry.js"]
    bundle: yes
    outfile: "#{dir}/main.js"
