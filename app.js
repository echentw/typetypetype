var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var exphbs = require('express-handlebars');
var session = require('express-session');
var fs = require('fs');

var app = express();
var http = require('http').Server(app);
var io = require('socket.io')(http);

var routes = require('./routes/index');
var home = require('./routes/home');

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.engine('.hbs', exphbs({extname: '.hbs'}));
app.set('view engine', '.hbs');

// uncomment after placing your favicon in /public
// app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
app.use(session({
  secret : fs.readFileSync('secret.txt', 'utf8'),
  resave : false,
  saveUninitialized : false
}));

app.use('/', routes);
app.use('/home', home);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

////////////////////// socket handlers
var players = [];
var sockets = [];
io.on('connection', function(socket) {
  socket.on('join', function(message) {
    if (sockets.indexOf(socket) === -1) {
      var name = message.name;
      players.push(name);
      sockets.push(socket);
      io.emit('player list', { players: players });
    }
  });

  socket.on('client message', function(message) {
    var name = message.name;
    var index = message.index;
    if (index < 3) {
      io.emit('typed word broadcast', { name: name, index: index });
    } else {
      io.emit('winner broadcast', { name: name });
    }
  });

  socket.on('disconnect', function() {
    var index = sockets.indexOf(socket);
    sockets.splice(index);
    players.splice(index);
    io.emit('player list', { players: players });
  });
});

////////////////////// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
  app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
      message: err.message,
      error: err
    });
  });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
  res.status(err.status || 500);
  res.render('error', {
    message: err.message,
    error: {}
  });
});

http.listen(3000, function() {
  console.log('listening on port 3000');
});

module.exports = app;
