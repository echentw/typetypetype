define(['socket-io'], (io) ->

  class Client
    constructor: (channelID, username) ->
      @channelID = channelID
      @username = username
      @socket = getSocket()
      @socket.emit('join', {channelID: channelID, username: username})

    ping: =>
      @socket.emit('hit', {channelID: @channelID, username: @username})

    getSocket = ->
      socket = io.connect()
      socket.on('update', (data) ->
        console.log data.message
      )
      socket.on('error', (data) ->
        console.log data.message
      )
      return socket

  return Client
)
