define(['socket-io'], (io) ->

  class Client
    constructor: (gameID, username) ->
      @gameID = gameID
      @username = username
      @socket = getSocket()
      @socket.emit('join', {gameID: gameID, username: username})

    ping: =>
      @socket.emit('hit', {gameID: @gameID, username: @username})

    getSocket = ->
      socket = io.connect()
      socket.on('update', (data) ->
        console.log data.message
      )
      socket.on('error', (data) ->
        console.log data.message
      )
      socket.on('player list', (data) ->
        $('#players').html('')
        for player in data.progresses.keys()
          $('#players').append('<p>' + player + '</p>')
          progress = data.progresses[player]

          progress_bar =
            '<div class="progress">' +
              '<div id = "' + players[i] + '-progress-bar" ' +
              'class="progress-bar" role="progressbar" aria-valuenow="' + progress + '" ' +
              'aria-valuemin="0" aria-valuemax="100" style="width:' + progress + '%">' +
                progress + '%' +
              '</div>' +
            '</div>'
        $('#players').append(progress_bar)
      )
      socket.on('countdown', (data) ->
        index = 0
        value = message.value
        $('#paragraph').html('')
        $('#start-button').html(value)
        $('#paragraph-container').find('#winner').remove()
        if value == '3'
          clearAllProgresses()
        else if value == 'Go!'
          words = data.words
          numWords = words.length
          for i in [0...numWords]
            $('#paragraph').append('<div id=' + i + '>' + words[i] + ' </div>')
      )

      return socket

  return Client
)
