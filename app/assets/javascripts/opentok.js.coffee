$ ->

  if $('#session').length

    # track the page
    mixpanel.track("User arguing about TOPIC HERE");

    # ragefaces!
    $('#video1').css({ background: "url(/assets/rage#{Math.round(Math.random() * 5) + 1}.jpg)" });

    # prompt sharing if nobody is there
    prompt_social = setTimeout (-> $('.social').fadeIn()), 10000

    # close the room if people leave
    exitFunction = ->
      console.log 'closing'
      $.ajax
        type: 'POST'
        url: "/close"
        data: { id: $('.room_id').text(), position: $('.position').text() }
        async : false
        success: (data) -> console.log data

    if window.onpagehide || window.onpagehide == null
      window.addEventListener 'pagehide', exitFunction, false
    else
      window.addEventListener 'unload', exitFunction, false

    # config
    apiKey = 20193772
    sessionId = $('.session-id').text()
    token = $('.token').text()
    position = parseInt($('.position').text().replace(/position_/, "")) - 1
    VIDEO_WIDTH = 466
    VIDEO_HEIGHT = 378

    console.log position

    sessionConnectedHandler = (event) ->
      subscribeToStreams(event.streams)
      $('#video1').append("<div id='#{position}'></div>");
      publisher = TB.initPublisher apiKey, "#{position}", { width: VIDEO_WIDTH, height: VIDEO_HEIGHT }
      session.publish publisher

    streamCreatedHandler = (e) ->
      subscribeToStreams e.streams

    subscribeToStreams = (streams) ->

      for stream in streams
        if  stream.connection.connectionId != session.connection.connectionId
          $('#video2').append "<div id='sub2'></div>"
          session.subscribe stream, 'sub2', { width: VIDEO_WIDTH, height: VIDEO_HEIGHT }
          clearTimeout prompt_social
          $('.social').fadeOut()

    exceptionHandler = (e) ->
      console.log "This page is trying to connect a third client to an OpenTok peer-to-peer session. Only two clients can connect to peer-to-peer sessions." if e.code == 1013

    # make the magic happen

    TB.addEventListener "exception", exceptionHandler
    session = TB.initSession sessionId
    session.addEventListener "sessionConnected", sessionConnectedHandler
    session.addEventListener "streamCreated", streamCreatedHandler
    session.connect apiKey, token    