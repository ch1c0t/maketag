os = require 'os'
{ createServer } = require 'http'

{ RespondWithFile } = require './server/respond_with_file'
{ PreparePageList } = require './server/pagelist'
{ PreparePage } = require './server/page'

exports.StartServer = ({ path }) ->
  root = '/tmp/maketag/assets.manual'

  server = createServer (request, response) ->
    switch request.url
      when '/', '/index.html'
        RespondWithFile {
          root
          response
          url: '/index.html'
          ContentType: 'text/html'
        }
      when '/main.js'
        RespondWithFile {
          root
          response
          url: request.url
          ContentType: 'text/javascript'
        }
      when '/page-list.js'
        PreparePageList().then (content) ->
          response.writeHead 200, 'Content-Type': 'text/javascript'
          response.end content
      else
        glob = require 'glob'
        { basename } = require 'path'
        glob "#{CWD}/spec/*.spec.coffee", nodir: yes, (error, files) ->
          names = for file in files
            basename file, '.spec.coffee'

          if request.url[1..] in names
            PreparePage(request.url)
              .then (content) ->
                response.writeHead 200, 'Content-Type': 'text/html'
                response.end content
              .catch (error) ->
                console.error error
                response.writeHead 500
                response.end "Error: #{error}"
          else
            response.writeHead 404
            response.end "Error: 404."

  server.listen 8081, ->
    urls = for _name, value of os.networkInterfaces()
      "  http://#{value[0].address}:8081"

    console.log """
      The server for manual testing is listening at:

      #{urls.join "\n"}
    """
