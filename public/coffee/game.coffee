require(['jquery', 'client'], ($, Client) ->

  $(document).ready( ->

    gameID = $('#gameID').text()
    username = $('#username').text()

    client = new Client(gameID, username)

    $('#ping').click( ->
      client.ping()
    )
  )
)
