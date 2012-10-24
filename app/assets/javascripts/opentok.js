(function() {

  $(function() {
    var connect_to_room, fixUnload, get_room, opts, prompt_social, run_find_room, spinner, target, unload;
    if ($('#session').length) {
      mixpanel.track("" + ($('.topic').text()));
      $('#video1').css({
        background: "url(/ragefaces/rage" + (Math.round(Math.random() * 5) + 1) + ".jpg)"
      });
      opts = {
        lines: 7,
        length: 0,
        width: 6,
        radius: 14,
        corners: 0.9,
        rotate: 0,
        color: '#d46d4a',
        speed: 1.2,
        trail: 47,
        shadow: true,
        hwaccel: false,
        className: 'spinner',
        zIndex: 10,
        top: 40,
        left: 40
      };
      target = document.getElementById('video1');

      function get_room(){
        $.ajax({
          type: 'POST',
          dataType: 'json',
          url: "/find",
          success: function(data) {
            console.log(data);
          }
        });
      };

      run_find_room = setTimeout(get_room(), 5000);

      prompt_social = setTimeout((function() {
        return $('.social').fadeIn();
      }), 10000);

      connect_to_room = function() {
        var VIDEO_HEIGHT, VIDEO_WIDTH, apiKey, appended_one, exceptionHandler, idle_timer, position, session, sessionConnectedHandler, sessionId, streamCreatedHandler, subscribeToStreams, token;
        apiKey = 20193772;
        sessionId = $('.session-id').text();
        token = $('.token').text();
        position = $('.position').text();
        VIDEO_WIDTH = 466;
        VIDEO_HEIGHT = 378;
        if (position !== 'observe') {
          idle_timer = setTimeout(function() {
            $('#flash').append("<div class='flash notice'>You've been sitting around for too long doing nothing. Come back when you're ready to chat!</div>");
            return setTimeout((function() {
              return window.location.href = 'http://shoutroulette.com';
            }), 2000);
          }, 90000);
        }
        sessionConnectedHandler = function(event) {
          var publisher;
          subscribeToStreams(event.streams);
          $('.spinner').remove();
          if (position !== 'observe') {
            $('#video1').append("<div id='" + position + "'></div>");
            publisher = TB.initPublisher(apiKey, "" + position, {
              width: VIDEO_WIDTH,
              height: VIDEO_HEIGHT
            });
            return session.publish(publisher);
          }
        };
        streamCreatedHandler = function(e) {
          clearTimeout(idle_timer);
          console.log('clicked accept');
          return subscribeToStreams(e.streams);
        };
        appended_one = false;
        subscribeToStreams = function(streams) {
          var num, stream, _i, _len, _results;
          _results = [];
          for (_i = 0, _len = streams.length; _i < _len; _i++) {
            stream = streams[_i];
            if (stream.connection.connectionId !== session.connection.connectionId) {
              if (position === 'observe') {
                num = !appended_one ? 1 : 2;
                $("#video" + num).append("<div id='s" + num + "'></div>");
                appended_one = true;
                session.subscribe(stream, "s" + num, {
                  width: VIDEO_WIDTH,
                  height: VIDEO_HEIGHT
                });
              } else {
                $('#video2').append("<div id='sub2'></div>");
                session.subscribe(stream, 'sub2', {
                  width: VIDEO_WIDTH,
                  height: VIDEO_HEIGHT
                });
              }
              clearTimeout(prompt_social);
              _results.push($('.social').fadeOut());
            } else {
              _results.push(void 0);
            }
          }
          return _results;
        };
        exceptionHandler = function(e) {
          if (e.code === 1013) {
            return console.log("This page is trying to connect a third client to an OpenTok peer-to-peer session. Only two clients can connect to peer-to-peer sessions.");
          }
        };
        TB.addEventListener("exception", exceptionHandler);
        session = TB.initSession(sessionId);
        session.addEventListener("sessionConnected", sessionConnectedHandler);
        session.addEventListener("streamCreated", streamCreatedHandler);
        return session.connect(apiKey, token);
      };
    }
  });

}).call(this);