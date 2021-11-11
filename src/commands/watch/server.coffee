{ createServer } = require 'http'

Respond = ({ root, response, url, ContentType }) ->
  IO
    .read "#{root}#{url}"
    .then (content) ->
      response.writeHead 200, 'Content-Type': ContentType
      response.end content
    .catch (error) ->
      console.error error
      response.writeHead 500
      response.end "Error: #{error}"

exports.StartServer = ({ path }) ->
  root = '/tmp/maketag/assets.manual'

  server = createServer (request, response) ->
    console.log request.url

    switch request.url
      when '/', '/index.html'
        Respond {
          root
          response
          url: '/index.html'
          ContentType: 'text/html'
        }
      when '/main.js', '/coffeescript.js'
        Respond {
          root
          response
          url: request.url
          ContentType: 'text/javascript'
        }
      else
        response.writeHead 404
        response.end "Error: 404."


  server.listen 8081, ->
    console.log """
      The server for manual testing is listening at the port 8081.
    """
