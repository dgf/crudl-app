crudl = require 'crudl-control'

module.exports = (express, everyone, model) ->

  express.get '/', (req, resp) -> resp.end 'hello'

  everyone.now.session = crudl model.Session, (session) ->
    id: session.id
    sid: session.sid
