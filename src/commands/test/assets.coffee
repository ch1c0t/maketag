assets = require '../../assets'

exports.CreateAssetsForAutomatedTesting = ->
  assets.CreateAssets
    dir: '/tmp/maketag/assets.auto'
    CreateIndexHTML: (dir) ->
      html = """
        <!DOCTYPE html>
        <html>
          <head>
            <title>A page for automatic tests</title>
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
