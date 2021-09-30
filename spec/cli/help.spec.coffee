{ sh } = require '@ch1c0t/sh'

describe 'help', ->
  it 'prints the help', ->
    response = await sh './bin/maketag'
    expect(response.stdout).toContain 'A tool to create tags'
