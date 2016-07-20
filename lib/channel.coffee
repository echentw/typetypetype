class Channel
  constructor: ->
    @users = {}

  addUser: (username) =>
    if username of @users
      return false
    @users[username] = true
    return true

  removeUser: (username) =>
    if username of @users
      delete @users[username]
      return true
    return false

  empty: ->
    return Object.keys(@users).length == 0

module.exports = Channel
