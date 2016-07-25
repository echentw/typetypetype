database = null

# GET home page
home = (req, res, next) ->
  res.render('home', {message: ''})
  return

# POST create a game
createGame = (req, res, next) ->
  # clear the current session
  req.session.gameID = null
  req.session.username = null

  # create new session
  gameID = database.add()
  req.session.gameID = gameID
  req.session.username = req.body['username']

  res.redirect('/game/' + gameID)

# POST join a game
joinGame = (req, res, next) ->
  # validate the request
  if !req.body['gameID'] || !req.body['username']
    res.redirect('/')
    return

  # clear the current session
  req.session.gameID = null
  req.session.username = null

  # check that the requested gameID exists
  game = database.find(req.body['gameID'])
  if game == null
    res.render('home', {message: 'There is no game with that ID.'})
    return
  if game.userExists(req.body['username'])
    res.render('home', {
      message: 'That name already already exists in that game.'
    })
    return

  req.session.gameID = req.body['gameID']
  req.session.username = req.body['username']

  res.redirect('/game/' + req.session.gameID)

# Attach route handlers to the app
module.exports.attach = (app, db) ->
  database = db
  app.get('/', home)
  app.post('/create', createGame)
  app.post('/join', joinGame)
