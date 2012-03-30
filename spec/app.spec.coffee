path = require 'path'
app = require('../src/app')

describe 'crudle application', ->

  config =
    name: 'test'
    model: 'model'
    control: 'control'

  it 'starts up all components', ->

    actual = app config, __dirname
    expect(actual.db.Session).toBeDefined 'session model'
