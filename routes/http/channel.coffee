# GET channel page
channel = (req, res, next) ->
  # validate the request
  if !req.session.channelID ||
      !req.session.username ||
      req.session.channelID != req.params['id']
    req.redirect('/')

  res.render('channel', {
    channelID: req.session.channelID,
    username: req.session.username
  })

module.exports.attach = (app, db) ->
  database = db
  app.get('/channel/:id', channel)
