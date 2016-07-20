express = require('express')
path = require('path')
favicon = require('serve-favicon')
logger = require('morgan')
cookieParser = require('cookie-parser')
expressSession = require('express-session')
sharedSession = require("express-socket.io-session")
bodyParser = require('body-parser')
fs = require('fs')
socket = require('socket.io')
http = require('http')
debug = require('debug')('typetypetype:server')

homeRoutes = require('./routes/http/home')
gameRoutes = require('./routes/http/game')
gameSocketRoutes = require('./routes/socket/game')

Database = require('./lib/db')

app = express()
server = http.createServer(app)
io = socket.listen(server)

session = expressSession({
  secret: [
    fs.readFileSync('keys/key0.txt', 'utf8'),
    fs.readFileSync('keys/key1.txt', 'utf8'),
    fs.readFileSync('keys/key2.txt', 'utf8')
  ],
  resave: true,
  saveUninitialized: true
})

database = new Database()

# view engine setup
app.set('views', path.join(__dirname, 'views'))
app.set('view engine', 'ejs')

# uncomment after placing your favicon in /public
#app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(logger('dev'))
app.use(bodyParser.json())
app.use(bodyParser.urlencoded(extended: false))
app.use(cookieParser())
app.use(session)
app.use(express.static(path.join(__dirname, 'public')))

# attach routes
homeRoutes.attach(app, database)
gameRoutes.attach(app, database)
gameSocketRoutes.attach(io, database)

io.use(sharedSession(session, {autoSave:true}))

# catch 404 and forward to error handler
app.use((req, res, next) ->
  err = new Error('Not Found')
  err.status = 404
  next(err)
)

##################################################
# error handlers
##################################################

# development error handler
# will print stacktrace
if app.get('env') == 'development'
  app.use((err, req, res, next) ->
    res.status err.status || 500
    res.render('error',
      message: err.message
      error: err
    )
  )

# production error handler
# no stacktraces leaked to user
app.use((err, req, res, next) ->
  res.status(err.status || 500)
  res.render('error',
    message: err.message
    error: {}
  )
)

##################################################
# server
##################################################

# Normalize a port into a number, string, or false.
normalizePort = (val) ->
  thePort = parseInt(val, 10)

  if isNaN(thePort)
    # named pipe
    return val

  if thePort >= 0
    # port number
    return thePort

  return false

# Get port from environment and store in Express.
port = normalizePort(process.env.PORT || '3000')

# Event listener for HTTP server "error" event.
onError = (error) ->
  if error.syscall != 'listen'
    throw error
  bind = if typeof port == 'string' then 'Pipe ' + port else 'Port ' + port
  # handle specific listen errors with friendly messages
  switch error.code
    when 'EACCES'
      console.error bind + ' requires elevated privileges'
      process.exit 1
    when 'EADDRINUSE'
      console.error bind + ' is already in use'
      process.exit 1
    else
      throw error
  return

# Event listener for HTTP server "listening" event.
onListening = ->
  addr = server.address()
  bind = if typeof addr == 'string' then 'pipe ' + addr else 'port ' + addr.port
  debug('Listening on ' + bind)
  return

app.set('port', port)

# Listen on provided port, on all network interfaces.
server.listen(port)
server.on('error', onError)
server.on('listening', onListening)
