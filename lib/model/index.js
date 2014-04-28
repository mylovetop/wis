// Generated by CoffeeScript 1.7.1
'use strict';
var client, config;

config = require('../config/config');

client = config.redis;

module.exports = (function() {
  return {
    user: require('./user')(client),
    game: require('./game')(client),
    player: require('./player')(client)
  };
})();