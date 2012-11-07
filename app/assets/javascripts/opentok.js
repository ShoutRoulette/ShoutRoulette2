      var sessionId = '';
      var token = '';
      var position = '';
      var interval = 0;
      var tries = 0;


      function get_room() {
        if (tries < 20)
        {
          $.ajax({
            type: 'POST',
            dataType: 'json',
            url: "/find",
            success: function(data) {
              console.log(data);
              if (data.matched == true)
              {
                clearInterval(interval);
                token = data.user_token;
                sessionId = data.room_session;
                connect_to_room();
                tries = 0;
              } else {
                 tries++;
              }
            }
          });
        } else {
          clearInterval(interval);
          alert('too many tries, not match, try another topic? [insert redirect script to home]');
        }
      }

      interval = setInterval("get_room()", 5000);
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


    }

      prompt_social = setTimeout((function() {
        return $('.social').fadeIn();
      }), 10000);
    function connect_to_room() {
        apiKey = 20193772;
        position = $('#position').html();
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
          $('.spinner').remove();
          if (position !== 'observe') {
            $('#video1').append("<div id='" + position + "'></div>");
            publisher = TB.initPublisher(apiKey, "" + position, {
              width: VIDEO_WIDTH,
              height: VIDEO_HEIGHT
            });
            return session.publish(publisher);
          }
          subscribeToStreams(event.streams);
        };
        streamCreatedHandler = function(e) {
          clearTimeout(idle_timer);
          console.log('clicked accept');
          return subscribeToStreams(e.streams);
        };
        appended_one = false;
        subscribeToStreams = function(streams) {
          console.log('subscribe');
          var num, stream, _i, _len, _results;
          _results = [];
          for (_i = 0, _len = streams.length; _i < _len; _i++) {
            console.log('subscribe'+_i);
            stream = streams[_i];
            console.log(stream);
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
        streamDestroyedHandler = function(e) {
          alert('user disconect, finding new');
          document.location.reload(true);
        };
        TB.addEventListener("exception", exceptionHandler);
        session = TB.initSession(sessionId);
        session.addEventListener("sessionConnected", sessionConnectedHandler);
        session.addEventListener("streamCreated", streamCreatedHandler);
        session.addEventListener("streamDestroyed", streamDestroyedHandler);
        return session.connect(apiKey, token);
      }

