define ['lib/zepto'], ($) ->
  init = () ->
    datalist = $("#jobSkillsDatalist")
    items = datalist.children()
    list = $("<ul></ul>")
    items.each () ->
      list.append("<li>" + $(this).attr("value") + "</li>")
    list.insertBefore(datalist)
    textarea = $("[name='skills']")
    list.on("click", "li", (e) ->
      val = textarea.val() + $(this).html() + ", "
      textarea.focus()
      textarea.val(val)
    )

  return init: init