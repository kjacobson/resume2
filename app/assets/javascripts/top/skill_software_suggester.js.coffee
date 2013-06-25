define ['lib/jquery'], ($) ->
  init = (tag_selector, target_selector) ->
    script_tag = $(tag_selector)
    datalist = $(script_tag.html())
    script_tag.replaceWith(datalist)
    textarea = $(target_selector)
    datalist.on("click", "li", (e) ->
      targ = $(this)
      val = textarea.val()
      item = targ.html()
      regex = new RegExp("(^|,\ *)(" + item + "(,\ *|$))", "gi")
      if targ.hasClass('in-use')
        val = val.replace(regex, '$1')
        targ.removeClass('in-use')
      else
        val += item + ", "
        targ.addClass('in-use')
      textarea.focus()
      textarea.val(val)
    )

  return init: init
