{ CreateAssets } = require '../../assets'

exports.CreateAssetsForManualTesting = ->
  dir = '/tmp/maketag/assets.manual'
  CreateAssets
    dir: dir
    CreateIndexHTML: (dir) ->
      html = """
        <!DOCTYPE html>
        <html>
          <head>
            <title>A page to test tags manually</title>
            <meta charset="utf-8">
            <meta http-equiv="x-ua-compatible" content="ie=edge">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
          </head>
          <body>
            <script src="/main.js"></script>
            <script src="/page-list.js"></script>
          </body
        </html>
      """
      IO.write "#{dir}/index.html", html
