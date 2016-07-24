define(['socket-io'], (io) ->

  class Client
    constructor: (gameID, username) ->
      @gameID = gameID
      @username = username
      @socket = @getSocket()
      @socket.emit('join', {gameID: gameID, username: username})

      @finishSound = new Audio('../assets/finish.wav')
      @keypressSound = []
      for i in [0...10]
        @keypressSound.push(new Audio('../assets/keypress.wav'))

      @numWords = -1
      @index = 0

    start: =>
      @socket.emit('start', {gameID: @gameID, username: @username})

    submit: =>
      name = @username
      word = $('#input_word').val()
      target = $('#' + @index).html()
      if target && word == target.substring(0, target.length - 1)
        $('#' + @index).fadeTo(100, 0.5)
        $('#input_word').val('')
        # if @index == @numWords
        #   finish_sound.play()

        @socket.emit('progress', {
          gameID: @gameID,
          username: @username,
          index: @index,
          word: word
        })
      else
        $('#' + @index).css('color', 'red')

    updateProgress: (name, progress) =>
      selector = '#' + name + '-progress-bar'
      $(selector).attr('aria-valuenow', progress)
      $(selector).attr('style', 'width:' + progress + '%')
      $(selector).html(progress + '%')

    clearAllProgresses: =>
      $('.progress-bar').each((index) ->
        $(this).attr('aria-valuenow', 0)
        $(this).attr('style', 'width:0%')
        $(this).html('0%')
      )

    getSocket: =>
      socket = io.connect()
      # socket = io()
      socket.on('update', (data) ->
        console.log data.message
      )
      socket.on('error', (data) ->
        console.log data.message
      )
      socket.on('player list', (data) ->
        $('#players').html('')
        for player of data.progresses
          $('#players').append('<p>' + player + '</p>')
          progress = data.progresses[player]

          progress_bar =
            '<div class="progress">' +
              '<div id = "' + player + '-progress-bar" ' +
              'class="progress-bar" role="progressbar" aria-valuenow="' + progress + '" ' +
              'aria-valuemin="0" aria-valuemax="100" style="width:' + progress + '%">' +
                progress + '%' +
              '</div>' +
            '</div>'
          $('#players').append(progress_bar)
      )
      socket.on('countdown', (data) =>
        @index = 0
        value = data.value
        $('#paragraph').html('')
        $('#start-button').html(value)
        $('#paragraph-container').find('#winner').remove()
        if value == '3'
          @clearAllProgresses()
        else if value == 'Go!'
          words = data.words
          numWords = words.length
          for i in [0...numWords]
            $('#paragraph').append('<div id=' + i + '>' + words[i] + ' </div>')
      )
      socket.on('progress', =>
        ++@index
      )
      socket.on('typed word broadcast', (data) =>
        @updateProgress(data.name, data.progress)
      )
      socket.on('winner broadcast', (data) =>
        @updateProgress(data.name, data.progress)
        $('#paragraph-container').append(
          '<h1 id="winner">' + data.name + ' wins!!!</h1>'
        )
      )

      return socket

  return Client
)
