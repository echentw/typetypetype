var express = require('express');
var router = express.Router();

var authenticate = function(req, res, next) {
  if (req.session.nickname) {
    next();
  } else {
    res.render('index', { message: 'That\'s weird... sorry about that.' });
  }
};

router.all('*', authenticate);

/* GET home page */
router.get('/', function(req, res, next) {
  var nickname = req.session.nickname;
  res.render('home');
});

module.exports = router;
