coffee = require 'coffeescript'
{ UpdateGlobalTAG } = require './tag/global'

exports.UpdateTAG = (source) ->
  { body } = coffee
    .compile source, ast: yes
    .program

  last = body[body.length-1]

  if last.type isnt 'ExpressionStatement'
    console.error """
      #{SRC}/script.coffee must end with an ExpressionStatement.
    """

  { expression } = last
  index = switch expression.type
    when 'CallExpression', 'FunctionExpression'
      last.loc.start.line - 1
    else
      console.error """
        #{SRC}/script.coffee must end with either a CallExpression or a FunctionExpression.
      """

  UpdateGlobalTAG expression
  index
