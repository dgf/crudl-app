path = require 'path'

exports.parse = (config, environment) ->
  #
    env = config[environment] || {}
    throw 'application name not found' if not config.name

    app:
      name: env.name || config.name
      port: env.port || config.port || 3000
      static: env.static || config.static || 'public'
      model: env.model || config.model || path.join 'src', 'model'
      view: env.view || config.view || path.join 'src', 'view'
      control: env.control || config.control || path.join 'src', 'control'
    db:
      name: env.database?.name || config.database?.name || config.name
      dialect: env.database?.dialect || config.database?.dialect || 'sqlite'
      storage: env.database?.storage || config.database?.storage || ':memory:'
      user: env.database?.user || config.database?.user || 'sa'
      pass: env.database?.password || config.database?.password || ''
