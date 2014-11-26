Application.fields = {}

Application.fields.setupCustomFields = ()->
  Application.fields.createTagFields()

Application.fields.createTagFields = ()->
  $('.select2').each ()->
    tags = $(@).data('tag-source')
    if !tags
      tags = []
    allowNewTags  = !$(@).data('restricted')

    if _.isString(tags) and tags.match(/Application.data/)
      tags = eval(tags)

    data = for tag in tags
      id: tag
      text: tag

    options = {tags}
    options.data = data unless allowNewTags is true

    $(@).select2(options)