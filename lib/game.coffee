fs = require('fs')

class Game
  constructor: ->
    @users = {}
    @progresses = {}
    @started = false
    @numWords = 20
    @paragraph = []

  addUser: (username) =>
    if username of @users
      return false
    @users[username] = true
    @progresses[username] = 0
    return true

  removeUser: (username) =>
    if username of @users
      delete @users[username]
      return true
    return false

  empty: =>
    return Object.keys(@users).length == 0

  getProgresses: =>
    return @progresses

  start: =>
    if @started
      return false

    fs.readFile('../words10k.txt', 'utf8', (err, data) ->
      words = data.split('\n')
      @paragraph = []
      for i in [0...@numWords]
        index = Math.floor(Math.random() * words.length)
        @paragraph.push(words[index])
    )
    @started = true
    return true

  getParagraph: =>
    return @paragraph

module.exports = Game
