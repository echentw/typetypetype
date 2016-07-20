database = null

# GET home page
home = (req, res, next) ->
  res.render('home')
  return

# POST create a channel
createChannel = (req, res, next) ->
  # clear the current session
  req.session.channelID = null
  req.session.username = null

  # create new session
  channelID = database.add()
  req.session.channelID = channelID
  req.session.username = req.body['username']

  res.redirect('/channel/' + channelID)

# POST join a channel
joinChannel = (req, res, next) ->
  # validate the request
  if !req.body['channelID'] || !req.body['username']
    res.redirect('/')
    return

  # clear the current session
  req.session.channelID = null
  req.session.username = null

  # check that the requested channelID exists
  if !database.find(req.body['channelID'])
    res.redirect('/')
    return

  req.session.channelID = req.body['channelID']
  req.session.username = req.body['username']

  res.redirect('/channel/' + req.session.channelID)

# Attach route handlers to the app
module.exports.attach = (app, db) ->
  database = db
  app.get('/', home)
  app.post('/create', createChannel)
  app.post('/join', joinChannel)
