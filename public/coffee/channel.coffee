require(['jquery', 'client'], ($, Client) ->

  $(document).ready( ->

    channelID = $('#channelID').text()
    username = $('#username').text()

    client = new Client(channelID, username)

    $('#ping').click( ->
      client.ping()
    )
  )
)
