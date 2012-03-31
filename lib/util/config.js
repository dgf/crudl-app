(function() {
  var path;

  path = require('path');

  exports.parse = function(config, environment) {
    var env, _ref, _ref10, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8, _ref9;
    env = config[environment] || {};
    if (!config.name) throw 'application name not found';
    return {
      app: {
        name: env.name || config.name,
        port: env.port || config.port || 3000,
        static: env.static || config.static || 'public',
        model: env.model || config.model || path.join('src', 'model'),
        view: env.view || config.view || path.join('src', 'view'),
        control: env.control || config.control || path.join('src', 'control')
      },
      db: {
        name: ((_ref = env.database) != null ? _ref.name : void 0) || ((_ref2 = config.database) != null ? _ref2.name : void 0) || config.name,
        dialect: ((_ref3 = env.database) != null ? _ref3.dialect : void 0) || ((_ref4 = config.database) != null ? _ref4.dialect : void 0) || 'sqlite',
        storage: ((_ref5 = env.database) != null ? _ref5.storage : void 0) || ((_ref6 = config.database) != null ? _ref6.storage : void 0) || ':memory:',
        user: ((_ref7 = env.database) != null ? _ref7.user : void 0) || ((_ref8 = config.database) != null ? _ref8.user : void 0) || 'sa',
        pass: ((_ref9 = env.database) != null ? _ref9.password : void 0) || ((_ref10 = config.database) != null ? _ref10.password : void 0) || ''
      }
    };
  };

}).call(this);
