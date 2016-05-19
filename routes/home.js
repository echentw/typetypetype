var express = require('express');
var router = express.Router();
var fs = require('fs');

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
  var text = fs.readFileSync('words10k.txt','utf8')
  var words = text.split('\n');
  var paragraph = [];
  for (var i = 0; i < 100; ++i) {
    var index = Math.floor(Math.random() * words.length);
    paragraph.push(words[index]);
  }
  var nickname = req.session.nickname;
  res.render('home', { name: nickname, words: paragraph });
});

module.exports = router;
