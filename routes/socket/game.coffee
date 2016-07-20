io = null
database = null

join = (data) ->
  socket = this

  gameID = data.gameID
  username = data.username

  if socket.handshake.session.gameID != gameID
    socket.emit('error', {message: 'Authentication failed.'})
    return

  game = database.find(gameID)
  if !game
    socket.emit('error', {message: 'The game does not exist.'})
    return

  success = game.addUser(username)
  if !success
    socket.emit('error', {message: 'Username already exists.'})
    return

  socket.join(gameID)

  message = username + ' joined game ' + gameID
  io.sockets.in(gameID).emit('update', {message: message})
  console.log message


disconnect = ->
  socket = this
  session = socket.handshake.session

  game = database.find(session.gameID)
  if !game
    return

  game.removeUser(session.username)

  message = session.username + ' left game ' + session.gameID
  console.log game.empty()
  if game.empty()
    database.delete(session.gameID)
  else
    io.sockets.in(session.gameID).emit('update', {message: message})

  console.log message

hit = (data) ->
  socket = this
  session = socket.handshake.session

  if session.gameID != data.gameID ||
      session.username != data.username
    socket.emit('error', {message: 'Authentication failed.'})
    return

  message = session.username + ' pinged game ' + session.gameID
  io.sockets.in(session.gameID).emit('update', {message: message})
  console.log message

module.exports.attach = (socketIO, db) ->
  database = db
  io = socketIO

  io.sockets.on('connection', (socket) ->
    socket.on('join', join)
    socket.on('disconnect', disconnect)
    socket.on('hit', hit)
  )
