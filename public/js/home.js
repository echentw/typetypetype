$(document).ready(function() {
  var socket = io();

  var index = 0;

  var submit = function() {
    var name = $('#name').html();
    var word = $('#input_word').val();
    var target = $('#' + index).html();
    if (word === target.substring(0, target.length - 1)) {
      $('#' + index).fadeTo(100, 0.5);
      ++index;
      socket.emit('client message', { name: name, index: index });
    } else {
      $('#' + index).css('color', 'red');
    }
    $('#input_word').val('');
  };
  $('#typed').on('keypress', function(e) {
    if (e.keyCode == 32 || e.keyCode == 13) {
      submit();
      return false;
    }
  });

  $('#join').submit(function() {
    var name = $('#name').html();
    socket.emit('join', { name: name });
    return false;
  });

  $('#start').submit(function() {
    socket.emit('start');
    return false;
  });

  socket.on('countdown', function(message) {
    $('#paragraph').html('');
    var value = message.value;
    $('#start-button').html(value);
    if (value === 'Go!') {
      var words = message.words;
      for (var i = 0; i < words.length; ++i) {
        $('#paragraph').append('<div id=' + i + '>' + words[i] + ' </div>');
      }
    }
  });

  socket.on('player list', function(message) {
    var players = message.players;
    $('#players').html('');
    for (var i = 0; i < players.length; ++i) {
      $('#players').append('<p>' + players[i] + '</p>');
    }
  });

  socket.on('typed word broadcast', function(message) {
    console.log(message.name + ' ' + message.index);
  });

  socket.on('winner broadcast', function(message) {
    $('#paragraph-container').append('<h1>' + message.name + ' wins!!!</h1>');
  });
});
