glob = require 'glob'
{ basename } = require 'path'
{ compile } = require 'coffeescript'

exports.PreparePageList = (root) ->
  new Promise (resolve, reject) ->
    glob "#{CWD}/spec/*.spec.coffee", nodir: yes, (error, files) ->
      if error?
        reject error
      else
        items = files
          .map (file) ->
            name = basename file
            href = '/' + name.split('.')[0]
            "  li [a href: '#{href}', '#{name}']"
          .join "\n"

        source = """
          { ul, li, a, p } = TAGS

          document.body.render [
            p 'You can choose a page from the list below:'
            ul [
            #{items}
            ]
          ]
        """

        resolve compile source
