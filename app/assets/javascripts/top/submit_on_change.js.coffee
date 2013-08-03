define ['lib/jquery'], ($) ->
  submitOnChange = (e, hideSubmit) ->
    form = $(e.target).closest('form')
    url = form.attr('action')
    # show busy indicator
    form.addClass('busy')
    $.ajax(
      url: url
      data: form.serialize()
      dataType: 'json'
      type: 'PUT'
    ).done(() ->
      # show success indicator
      form.removeClass('busy').addClass('success')
      # remove success indicator
      setTimeout(() ->
        form.removeClass('success')
      , 3000)
      return
    ).fail(() ->
      # show error indicator
      form.removeClass('busy').addClass('errpr')
      # post message to message center somewhere
      setTimeout(() ->
        form.removeClass('error')
      , 3000)
      return
    )
    return

  init = (selector, hideSubmit) ->
    form = 0
    submit = 0
    $(selector).each(() ->
      form = $(this).closest('form')
      submit = form.find('[type="submit"]')
      submit.remove()
    )
    $(document).on('change', selector, (e) ->
        submitOnChange(e, hideSubmit)
        e.preventDefault()
    )
    return

  return {
    init: init
  }