Application.billing = ()->
  onEventsPage = $('form').attr('action')?.match(/events/)
  if onEventsPage
    $('#billing_reference_name').on "change", ->
      $("#billing_reference_tag_list").select2("val", "")
      setData()

    setData = ->
      selectedText = $("#billing_reference_name option:selected").text()
      if selectedText
        tmpData = Application.data.account_reference_choices[selectedText]
        data = []
        $.each tmpData, (index, value) ->
          data.push {id: value, text: value} 
        $("#billing_reference_tag_list").select2({data:data, multiple:false})
        $("#billing_reference_tag_list").parent().parent().show()
      else
        $("#billing_reference_tag_list").parent().parent().hide()

    setData()

