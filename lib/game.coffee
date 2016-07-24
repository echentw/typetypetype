fs = require('fs')

class Game
  constructor: ->
    @users = {}
    @progresses = {}
    @started = false
    @numWords = 3
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
      delete @progresses[username]
      return true
    return false

  empty: =>
    return Object.keys(@users).length == 0

  getProgresses: =>
    return @progresses

  start: =>
    if @started
      return false

    fs.readFile('./assets/words10k.txt', 'utf8', (err, data) =>
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

  progress: (username, index, word) =>
    if word != @paragraph[index]
      return {success: false}

    ++index

    if index < @numWords
      progress = Math.floor(index / @numWords * 100)
      @progresses[username] = progress
      return {success: true, winner: false, progress: progress}
    else
      @progresses[username] = 100
      if @started
        @started = false
        return {success: true, winner: true, progress: 100}
      else
        return {success: true, winner: false, progress: 100}

module.exports = Game
