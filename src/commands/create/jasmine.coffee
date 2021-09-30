{ sh } = require '@ch1c0t/sh'

CreateJasmineSetup = ({ name, directory }) ->
  await IO.mkdir directory
  await CreateSupport { directory: "#{directory}/support" }
  await CreateSomeSpec { name, directory }

CreateSupport = ({ directory }) ->
  await IO.ensure directory
  await IO.write "#{directory}/coffee.cjs", "require('coffeescript/register')"

  config =
    spec_dir: 'spec'
    spec_files: [
      '**/*.spec.coffee'
    ]
    helpers: [
      'support/coffee.cjs'
      'helpers/**/*.coffee'
    ]
    stopSpecOnExpectationFailure: no
    random: yes
  await IO.write "#{directory}/jasmine.json", (JSON.stringify config, null, 2)

CreateSomeSpec = ({ name, directory }) ->
  source = """
    describe 'tag', ->
      it 'expects peculiar', ->
        expect(0).toBe 1
  """

  IO.write "#{directory}/main.spec.coffee", source

module.exports = { CreateJasmineSetup }
