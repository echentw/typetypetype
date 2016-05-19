$(document).ready(function() {
  var socket = io();

  var index = 0;

  $('#typed').submit(function() {
    var name = $('#name').html();
    var word = $('#input_word').val();
    var target = $('#' + index).html();
    if (word === target) {
      $('#' + index).remove();
      ++index;
      socket.emit('client message', { name: name, index: index });
    }
    $('#input_word').val('');
    return false;
  });

  socket.on('typed word broadcast', function(message) {
    console.log(message.name + ' ' + message.index);
  });

  socket.on('winner broadcast', function(message) {
    $('#winner').html(message.name + ' wins!!!');
    $('#paragraph').remove();
  });
});
