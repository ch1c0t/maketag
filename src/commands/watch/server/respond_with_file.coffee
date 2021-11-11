exports.RespondWithFile = ({ root, response, url, ContentType }) ->
  IO
    .read "#{root}#{url}"
    .then (content) ->
      response.writeHead 200, 'Content-Type': ContentType
      response.end content
    .catch (error) ->
      console.error error
      response.writeHead 500
      response.end "Error: #{error}"
