$(document).ready(function() {
  var socket = io();

  $('form').submit(function() {
    var word = $('#input_word').val();
    console.log(word);
    socket.emit('typed word', word);
    $('#input_word').val('');
    return false;
  });

  socket.on('typed word broadcast', function(message) {
    $('#words').append($('<li>').text(message));
  });
});
