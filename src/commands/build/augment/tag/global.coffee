exports.UpdateGlobalTAG = (expression) ->
  switch expression.type
    when 'FunctionExpression'
      TAG.type = 'wrapped'
    when 'CallExpression'
      if expression.callee.name isnt 'tag'
        console.error """
          #{SRC}/script.coffee must end with a tag.
        """

      argument = expression.arguments[0]
      switch argument.type
        when 'StringLiteral'
          TAG.type = 'named'
          TAG.name = argument.value
        else
          TAG.type = 'nameless'
