{ sh } = require '@ch1c0t/sh'

CreateJasmineSetup = ({ name, directory }) ->
  await IO.mkdir directory
  await CreateSomeSpec { name, directory }

CreateSomeSpec = ({ name, directory }) ->
  source = """
    describe '#{TAG.name}', ->
      SetupPage ->
        window.ROOT = #{TAG.name} name: 'Ruby'

      it 'works', ->
        html = await @page.evaluate -> ROOT.innerHTML
        expect(html).toBe '<div>Hello, Ruby.</div>'
  """

  IO.write "#{directory}/main.spec.coffee", source

module.exports = { CreateJasmineSetup }
