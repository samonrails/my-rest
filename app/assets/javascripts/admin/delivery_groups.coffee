$ ->
  accountNames          = $("ul#available-accounts li strong")
  accountLocations      = $("ul#available-accounts ul.account")
  selectedAccountsTable = $("table#selected-accounts")
  button                = $('input#save-delivery-group')
  selectedAccountsBody  = selectedAccountsTable.find("tbody")
  locations             = accountLocations.find("li")

  accountLocations.hide()
  locations.draggable()

  reCountGroups = ->
    selectedAccountsBody.find("tr:visible").each (i, tr) ->
      row = $(tr)
      td  = $(row.find("td")[1])
      num = i + 1
      td.html(num)

  insertRow = (elem) ->
    source   = $("#delivery-group-template").html()
    template = Handlebars.compile(source)
    account  = elem.data("account")
    location = elem.data("location")
    id       = elem.data("id")
    html     = template({id: id, account: account, location: location, num: "" })

    elem.remove()
    selectedAccountsBody.append(html)

  accountNames.on "click", (e) ->
    e.preventDefault()
    $(this).siblings("ul.account").toggle()

  button.on "click", (e) ->
    e.preventDefault()
    url = $('form#new_delivery_group').attr('action')

    if url
      $.post url, formData(), (response) => refresh()
    else
      url = $('form.edit_delivery_group').attr('action')

      $.ajax
        url: url,
        data: formData(),
        type: 'PUT',
        success: (response) => refresh()

  refresh = ->
    window.location = "/admin?selected=delivery_groups"

  formData = ->
    name       = $('#delivery_group_name').val()
    account_id = $('#delivery_group_account_id').val()
    ids        = _.map selectedAccountsBody.find("tr:visible"), (tr) -> $(tr).data("id")
    {account_id: account_id, delivery_group: {name: name, location_ids: ids}}

  rebindTable = ->
    $('button.delete').on "click", (e) ->
      e.preventDefault()
      $(this).parents('tr').remove()
      reCountGroups()

  selectedAccountsTable.droppable
    drop: (event, ui) ->
      elem = $(ui.draggable)
      insertRow(elem) if elem.prop("tagName") is "LI"
      reCountGroups()
      makeSortable()
      rebindTable()

  makeSortable = ->
    reCountGroups()
    selectedAccountsBody.disableSelection()

    selectedAccountsBody.sortable
      sort: (event, ui) -> reCountGroups()
      update: (event, ui) -> reCountGroups()

  makeSortable() # For editing a DG

