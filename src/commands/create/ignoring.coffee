exports.CreateIgnoringFiles = ->
  await IO.write "#{DIR}/.gitignore", """
    lib
  """

  await IO.write "#{DIR}/.npmignore", """
    src
    spec
  """
