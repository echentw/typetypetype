Game = require('./game')

class Database
  EXPIRE_TIME_IN_MILLISECONDS = 60 * 60 * 1000
  CHARS = '1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM'

  constructor: ->
    @games = {}

    setInterval(((games) ->
      for key of games
        # check if there has been no activity
        if false
          delete games[key]
    ), EXPIRE_TIME_IN_MILLISECONDS, @games)

  add: =>
    key = generateKey(16)
    while key of @games
      key = generateKey(16)

    @games[key] = new Game()
    return key

  find: (key) =>
    if key of @games
      return @games[key]
    return null

  delete: (key) =>
    if key of @games
      delete @games[key]
      return true
    return false

  generateKey = (keyLength) =>
    key = ''
    for i in [0...keyLength]
      key += CHARS[Math.floor(Math.random() * CHARS.length)]
    return key

module.exports = Database
