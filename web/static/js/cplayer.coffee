CPlayer =
  init: (domId, playerId, onReady) ->
    console.log "works #{video.id}"
    window.onYouTubeIframeAPIReady = () =>
      @onIframeReady(domId, playerId, onReady)
    youtubeScriptTag = document.createElement("script")
    youtubeScriptTag.src = "//www.youtube.com/iframe_api"
    document.head.appendChild(youtubeScriptTag)

  onIframeReady: (domId, playerId, onReady) ->
    @player = new YT.Player(domId, {
      height: "360",
      width: "420",
      videoId: playerId,
      events: {
        "onReady": (event) => onReady(event)
        "onStateChange": (event) => @onPlayerStateChange(event)
      }
    })

  onPlayerStateChange: (event) ->
    console.log("player changed")
    console.log(event)

  getCurrentTime: ->
    Math.floor(@player.getCurrentTime() * 1000)

  seekTo: (millsec) ->
    @player.seekTo(millsec / 1000)


module.exports =
  CPlayer: CPlayer
