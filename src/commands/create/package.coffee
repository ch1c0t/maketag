{ hyphenate } = require 'hyphenate.pascalcase'

exports.CreatePackageFile = ({ name }) ->
  hyphenated = hyphenate name
  spec =
    name: hyphenated
    type: 'module'
    main: 'lib/main.js'
    version: '0.0.0'
    scripts:
      build: "maketag build"
      start: "maketag watch"
      test: "maketag test"
    dependencies:
      'web.tags': 'file:../../web.tags'
    devDependencies:
      maketag: "file:.."
      serve: "^12.0.1"

  type = if (hyphenated.includes '-') then 'named' else 'nameless'
  spec.tag = { name, type }

  source = JSON.stringify spec, null, 2
  IO.write "#{DIR}/package.json", source
