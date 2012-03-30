path = require 'path'
{parse} = require('../src/util/config')

describe 'configuration parsing', ->
#
  config =
    name: 'glossary'
    development:
      name: 'glossary dev mode'
      static: 'public-dev'
      model: 'model-dev'
      view: 'view-dev'
      control: 'control-dev'
      database:
        name: 'glossary-dev'
        storage: 'file.db'
        user: 'root'
        password: ''
    production:
      name: 'glossary production mode'
      port: 80
      database:
        dialect: 'mysql'
        user: 'glossary-webapp'
        password: 'secret'

  it 'needs an app name', ->
    try
      parse development: database: nothing: 'defined'
      @fail 'configuration accepted'
    catch error
      expect(error).toBeDefined 'error message'

  it 'has some handy defaults to start directly with an appliction name', ->
    # without specific environment
    actual = parse config
    expect(actual.app.name).toBe config.name, 'app name'
    expect(actual.app.port).toBe 3000, 'port'
    expect(actual.app.static).toBe 'public', 'static sources'
    expect(actual.app.model).toBe path.join('src', 'model'), 'Sequelize model definitions'
    expect(actual.app.view).toBe path.join('src', 'view'), 'jade view templates'
    expect(actual.app.control).toBe path.join('src', 'control'), 'app controller and routes'
    expect(actual.db.name).toBe config.name, 'app name too'
    expect(actual.db.dialect).toBe 'sqlite', 'dialect'
    expect(actual.db.storage).toBe ':memory:', 'storage'
    expect(actual.db.user).toBe 'sa', 'default user'
    expect(actual.db.pass).toBe '', 'empty password'

  it 'ignores unknown environments', ->
    actual = parse config, 'unknown'
    expect(actual.app.name).toBe config.name, 'app name'

  describe 'properties can be overwritten by environment', ->
  #
    it 'considers development configuration', ->
      actual = parse config, 'development'
      expect(actual.app.name).toBe config.development.name, 'name'
      expect(actual.app.port).toBe 3000, 'default port'
      expect(actual.app.static).toBe config.development.static, 'static sources'
      expect(actual.app.model).toBe config.development.model, 'Sequelize model definitions'
      expect(actual.app.view).toBe config.development.view, 'jade view templates'
      expect(actual.app.control).toBe config.development.control, 'app controller and routes'
      expect(actual.db.name).toBe config.development.database.name, 'name'
      expect(actual.db.dialect).toBe 'sqlite', 'dialect'
      expect(actual.db.storage).toBe config.development.database.storage, 'storage'
      expect(actual.db.user).toBe config.development.database.user, 'user'
      expect(actual.db.pass).toBe config.development.database.password, 'password'

    it 'considers production configuration', ->
      actual = parse config, 'production'
      expect(actual.app.name).toBe config.production.name, 'app name'
      expect(actual.app.port).toBe 80, 'port'
      expect(actual.app.static).toBe 'public', 'static sources'
      expect(actual.app.model).toBe path.join('src', 'model'), 'Sequelize model definitions'
      expect(actual.app.view).toBe path.join('src', 'view'), 'jade view templates'
      expect(actual.app.control).toBe path.join('src', 'control'), 'app controller and routes'
      expect(actual.db.name).toBe config.name, 'db name'
      expect(actual.db.dialect).toBe config.production.database.dialect, 'dialect'
      expect(actual.db.storage).toBe ':memory:', 'storage'
      expect(actual.db.user).toBe config.production.database.user, 'user'
      expect(actual.db.pass).toBe config.production.database.password, 'password'
