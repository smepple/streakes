jQuery ->

  # Fade out flash message
  $ ->
    $(".flash-messages").delay(500).fadeIn "normal", ->
      $(this).delay(500).fadeOut()
