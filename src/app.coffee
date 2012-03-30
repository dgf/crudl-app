path = require 'path'
express = require 'express'
assets = require 'connect-assets'
now = require 'now'
Sequelize = require 'sequelize'
C3Store = require('c3store') express

{parse} = require('./util/config')

module.exports = (config, appDir) ->

  cfg = parse config, process.env['NODE_ENV']

  sequelize = new Sequelize cfg.db.name, cfg.db.user, cfg.db.pass,
    dialect: cfg.db.dialect
    storage: cfg.db.storage
  sessionStore = new C3Store sequelize
  model = require path.join appDir, cfg.app.model
  db = model sequelize, sessionStore.SequelizeSession

  app = express.createServer()

  app.configure ->
    app.set 'views', cfg.app.view
    app.set 'view engine', 'jade'
    app.set 'view options',
      layout: false,
      pretty: true
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use express.cookieParser()
    app.use assets()
    #app.use assets(src: path.join __dirname, 'assets') # @todo absolute path FOO!
    app.use express.staticCache()

  app.configure 'development', ->
    console.error 'configure development'
    app.use express.logger('dev')
    app.use express.static(cfg.app.static)
    app.use express.errorHandler(dumpExceptions: true, showStack: true)
    app.use express.session
      secret: "MyAwesomeAppSessionSecret",
      store: sessionStore
    app.use app.router

  app.configure 'production', ->
    console.error 'configure production'
    oneYear = 31557600000;
    app.use express.logger('default')
    app.use express.static(cfg.app.static, maxAge: oneYear)
    app.error (err, req, res) -> res.render '500', error: err
    app.use express.session
      secret: "MyAwesomeAppSessionSecret",
      store: sessionStore
    app.use app.router

  everyone = now.initialize app
  require(path.join appDir, cfg.app.control) app, everyone, db

  db: db
  app: app
  now: everyone
  start: -> app.listen cfg.app.port, -> console.log 'Listening...'
