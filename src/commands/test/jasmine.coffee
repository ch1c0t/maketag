Jasmine = require 'jasmine'

exports.RunJasmine = ->
  jasmine = new Jasmine
  jasmine.loadConfig
    spec_dir: 'spec'
    spec_files: [
      '**/*.spec.coffee'
    ]
    helpers: [
      "#{__dirname}/jasmine/helpers.js"
      'helpers/**/*.coffee'
    ]

  jasmine.execute()
