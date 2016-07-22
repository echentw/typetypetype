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

  )
)
