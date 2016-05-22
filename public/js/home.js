$(document).ready(function() {
  var socket = io();

  var name = $('#name').html();
  socket.emit('join', { name: name });

  var finish_sound = new Audio('../assets/finish.wav');
  var keypress_sound = [];
  var keypress_ctr = 0;
  for (var i = 0; i < 10; ++i) {
    keypress_sound.push(new Audio('../assets/keypress.wav'));
  }

  var num_words = -1;
  var index = 0;

  $('#left').fadeIn(300, function() {
    $('#right').fadeIn(300, function() {
      $('#left-content').fadeIn(1000);
      $('.text-center').fadeIn(1000);
    });
  });

  var updateProgress = function(name, progress) {
    $('#' + name + '-progress-bar').attr('aria-valuenow', progress);
    $('#' + name + '-progress-bar').attr('style', 'width:' + progress + '%');
    $('#' + name + '-progress-bar').html(progress + '%');
  };

  var clearAllProgresses = function() {
    $('.progress-bar').each(function(index) {
      $(this).attr('aria-valuenow', 0);
      $(this).attr('style', 'width:0%');
      $(this).html('0%');
    });
  };

  var submit = function() {
    var name = $('#name').html();
    var word = $('#input_word').val();
    var target = $('#' + index).html();
    if (target && word === target.substring(0, target.length - 1)) {
      $('#' + index).fadeTo(100, 0.5);
      $('#input_word').val('');
      ++index;
      if (index === num_words) {
        finish_sound.play();
      }
      socket.emit('progress', { name: name, index: index });
      updateProgress(index / num_words * 100);
    } else {
      $('#' + index).css('color', 'red');
    }
  };
  var keypressed = {};
  $('#typed').keydown(function(e) {
    if (!keypressed[e.keyCode]) {
      keypressed[e.keyCode] = true;
      keypress_sound[keypress_ctr].play();
      keypress_ctr = (keypress_ctr + 1) % keypress_sound.length;
    }
    if (e.keyCode == 32 || e.keyCode == 13) {
      submit();
      return false;
    }
  });
  $('#typed').keyup(function(e) {
    if (keypressed[e.keyCode]) {
      keypressed[e.keyCode] = false;
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
    if (value === '3') {
      clearAllProgresses();
    } else if (value === 'Go!') {
      var words = message.words;
      num_words = words.length;
      for (var i = 0; i < num_words; ++i) {
        $('#paragraph').append('<div id=' + i + '>' + words[i] + ' </div>');
      }
    }
  });

  socket.on('player list', function(message) {
    var players = message.players;
    var progresses = message.progresses;
    $('#players').html('');
    for (var i = 0; i < players.length; ++i) {
      $('#players').append('<p>' + players[i] + '</p>');
      var progress = progresses[i];
      var progress_bar =
          '<div class="progress">' +
            '<div id = "' + players[i] + '-progress-bar" ' +
            'class="progress-bar" role="progressbar" aria-valuenow="' + progress + '" ' +
            'aria-valuemin="0" aria-valuemax="100" style="width:' + progress + '%">' +
              progress + '%' +
            '</div>' +
          '</div>';
      $('#players').append(progress_bar);
    }
  });

  socket.on('typed word broadcast', function(message) {
    var name = message.name;
    var progress = message.progress;
    updateProgress(name, progress);
  });

  socket.on('winner broadcast', function(message) {
    updateProgress(message.name, message.progress);
    var html = '<h1 id="winner">' + message.name + ' wins!!!</h1>';
    $('#paragraph-container').append(html);
  });
});
