var express = require('express');
var router = express.Router();

/* GET index page */
router.get('/', function(req, res, next) {
  res.render('index');
});

/* POST index page */
router.post('/', function(req, res, next) {
  req.session.nickname = req.body.nickname;
  res.redirect('home');
});

module.exports = router;
