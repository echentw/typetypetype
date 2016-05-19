$(document).ready(function() {
  var socket = io();

  $('#typed').submit(function() {
    var name = $('#name').html();
    var word = $('#input_word').val();
    socket.emit('client message', { name: name, word: word });
    $('#input_word').val('');
    return false;
  });

  socket.on('typed word broadcast', function(message) {
    $('#words').append($('<li>').text(message));
  });
});
