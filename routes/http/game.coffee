# GET game page
game = (req, res, next) ->
  # validate the request
  if !req.session.gameID ||
      !req.session.username ||
      req.session.gameID != req.params['id']
    req.redirect('/')

  res.render('game', {
    gameID: req.session.gameID,
    username: req.session.username
  })

module.exports.attach = (app, db) ->
  database = db
  app.get('/game/:id', game)
