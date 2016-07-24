require(['jquery', 'client'], ($, Client) ->

  $(document).ready( ->
    gameID = $('#gameID').text()
    username = $('#username').text()

    client = new Client(gameID, username)

    $('#left').fadeIn(300, ->
      $('#right').fadeIn(300, ->
        $('#left-content').fadeIn(1000)
        $('.text-center').fadeIn(1000)
      )
    )

    $('#start').submit( ->
      client.start()
      return false
    )

    keypressed = {}
    $('#typed').keydown((e) ->
      if !keypressed[e.keyCode]
        keypressed[e.keyCode] = true
        # keypress_sound[keypress_ctr].play()
        # keypress_ctr = (keypress_ctr + 1) % keypress_sound.length
      if e.keyCode == 32 || e.keyCode == 13
        client.submit()
        return false
    )
    $('#typed').keyup((e) ->
      if keypressed[e.keyCode]
        keypressed[e.keyCode] = false
    )
  )
)
