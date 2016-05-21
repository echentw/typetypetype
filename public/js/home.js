$(document).ready(function() {
  var socket = io();

  var name = $('#name').html();
  socket.emit('join', { name: name });

  var index = 0;

  $('#left').fadeIn(300, function() {
    $('#right').fadeIn(300, function() {
      $('#left-content').fadeIn(1000);
      $('.text-center').fadeIn(1000);
    });
  });

  var submit = function() {
    var name = $('#name').html();
    var word = $('#input_word').val();
    var target = $('#' + index).html();
    if (word === target.substring(0, target.length - 1)) {
      $('#' + index).fadeTo(100, 0.5);
      $('#input_word').val('');
      ++index;
      socket.emit('client message', { name: name, index: index });
    } else {
      $('#' + index).css('color', 'red');
    }
  };
  $('#typed').on('keypress', function(e) {
    if (e.keyCode == 32 || e.keyCode == 13) {
      submit();
      return false;
    }
  });

  $('#start').submit(function() {
    socket.emit('start');
    return false;
  });

  socket.on('countdown', function(message) {
    index = 0;
    var value = message.value;
    $('#paragraph').html('');
    $('#start-button').html(value);
    $('#paragraph-container').find('#winner').remove();
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
    var html = '<h1 id="winner">' + message.name + ' wins!!!</h1>';
    $('#paragraph-container').append(html);
  });
});
