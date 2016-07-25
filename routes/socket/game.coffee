io = null
database = null

join = (data) ->
  socket = this

  gameID = data.gameID
  username = data.username

  if socket.handshake.session.gameID != gameID
    socket.emit('eror', {message: 'Authentication failed.'})
    return

  game = database.find(gameID)
  if !game
    socket.emit('eror', {message: 'The game does not exist.'})
    return

  success = game.addUser(username)
  if !success
    socket.emit('eror', {message: 'Username already exists.'})
    return

  socket.join(gameID)

  io.sockets.in(gameID).emit('player list', {progresses: game.progresses})

disconnect = ->
  socket = this
  session = socket.handshake.session

  game = database.find(session.gameID)
  if !game
    return

  game.removeUser(session.username)

  if game.empty()
    database.delete(session.gameID)
  else
    io.sockets.in(session.gameID).emit('player list', {
      progresses: game.progresses
    })

start = (data) ->
  socket = this
  session = socket.handshake.session

  if session.gameID != data.gameID ||
      session.username != data.username
    socket.emit('eror', {message: 'Authentication failed'})

  game = database.find(data.gameID)
  if !game
    socket.emit('eror', {message: 'Game not found.'})
    return

  if game.start()
    setTimeout( ->
      io.sockets.in(session.gameID).emit('countdown', {value: '3'})
    , 1000)
    setTimeout( ->
      io.sockets.in(session.gameID).emit('countdown', {value: '2'})
    , 2000)
    setTimeout( ->
      io.sockets.in(session.gameID).emit('countdown', {value: '1'})
    , 3000)
    setTimeout( ->
      io.sockets.in(session.gameID).emit('countdown', {
        value: 'Go!', words: game.getParagraph()
      })
    , 4000)

  return

progress = (data) ->
  socket = this
  session = socket.handshake.session

  if session.gameID != data.gameID ||
      session.username != data.username
    socket.emit('eror', {message: 'Authentication failed'})
    return

  game = database.find(data.gameID)
  if !game
    socket.emit('eror', {message: 'Game not found.'})
    return

  result = game.progress(data.username, data.index, data.word)
  if !result.success
    socket.emit('eror', {message: 'Something went wrong!'})
    return

  socket.emit('progress')
  if result.winner
    io.sockets.in(session.gameID).emit('winner broadcast', {
      name: data.username, progress: result.progress
    })
  else
    io.sockets.in(session.gameID).emit('typed word broadcast', {
      name: data.username, progress: result.progress
    })

module.exports.attach = (socketIO, db) ->
  database = db
  io = socketIO

  io.sockets.on('connection', (socket) ->
    socket.on('join', join)
    socket.on('disconnect', disconnect)
    socket.on('start', start)
    socket.on('progress', progress)
  )
