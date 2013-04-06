jQuery ->

  # Fade in pages
  $(".container").delay(120).animate opacity: "1"

  # Add focus to first input field on page load
  $("input:visible:first").focus();