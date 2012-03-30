path = require 'path'
crudl = require 'crudl-model'

module.exports = (sequelize, Session) ->

  loadModel = (name) => require(path.join __dirname, name) sequelize

  @Session = crudl Session

  @reset = (onSuccess, onError) ->
    sequelize.sync(force: true).success(onSuccess).error(onError)

  @
