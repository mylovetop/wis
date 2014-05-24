// Generated by CoffeeScript 1.7.1
'use strict';
var Key, User, async, dump, jf, load, print, redis, util, _;

_ = require('lodash');

redis = require('redis').createClient();

async = require('async');

util = require('util');

User = require('../../../lib/models/user');

jf = require('jsonfile');

jf.spaces = 4;

dump = './dump.json';

Key = (function() {
  return {
    uid: 'wis:id:user',
    idxUsername: 'wis:index:username',
    idxUid: 'wis:index:uid',
    login: 'wis:login',
    profile: function(id) {
      return "wis:user:" + id;
    }
  };
})();

print = function(err, result) {
  return console.log(err, result);
};

load = function(uid, done) {
  return async.waterfall([
    function(callback) {
      return redis.hgetall(Key.profile(uid), function(err, profile) {
        profile = _.merge({
          uid: uid
        }, profile);
        return callback(err, profile);
      });
    }, function(profile, callback) {
      return redis.hget(Key.login, uid, function(err, hash) {
        profile.password = hash;
        return callback(err, profile);
      });
    }
  ], done);
};

User.all(function(err, ids) {
  var finds;
  finds = _.map(ids, function(uid) {
    return function(callback) {
      return load(uid, callback);
    };
  });
  return async.parallel(finds, function(err, results) {
    console.log(results);
    return jf.writeFile(dump, results, function(err) {
      return console.log({
        err: err
      });
    });
  });
});
