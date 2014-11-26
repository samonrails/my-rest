Application.SitewideSearch = Backbone.View.extend
  events:
    "click .btn-group li a":  "setSearchFilter"
    "click .search-action":   "performSearch"
    "keyup input":            "onKeyPress"
    "keyup .search-results":  "onKeyPress"
    "mouseover .search-result":   "setActiveSearchResult"

  throttle: 200

  minSearchLength: 3

  initialize: (@options={})->
    @throttledSearch = _.debounce(@performSearch, @throttle)

    Backbone.View::initialize.apply(@, arguments)

    @index = new Application.IndexTracker()

    @index.on "change", @highlightSelectedSearchResult, @
    @render()

  setSearchFilter: (e)->
    target = @$(e.target).closest('a')
    e.preventDefault()

    @searchFilter = target.data('search-filter')

    display = if @searchFilter then _.str.capitalize(@searchFilter) else "Search All"
    @$('.search-action').html( display )
    @performSearch()

  onKeyPress: (e)->
    switch e.which
      when 13
        e.preventDefault()

        if @index.value() >= 0
          resultElement = @getSelectedSearchResult()
          # why can't i just pretend to click?
          if link = resultElement.find('a')
            window.location = link.attr('href') if link.attr('href')?
        else
          @performSearch(true)

      when 38
        e.preventDefault()
        @onDownArrow()
      when 40
        e.preventDefault()
        @onUpArrow()
      else
        @throttledSearch()

  setActiveSearchResult: (e)->
    target = @$(e.target).closest('.search-result')
    @index.set 'index', target.index()

  getSelectedSearchResult: ()->
    element = @$('.search-results .search-result').eq @index.value()

  highlightSelectedSearchResult: ()->
    index = @index.value()
    @$('.search-results .search-result').removeClass('selected').eq(index).addClass('selected')

  onDownArrow: ()->
    @index.decrement()

  onUpArrow: ()->
    count = @$('.search-result').length - 1
    @index.increment(count)

  performSearch: (bypassMinLengthCheck)->
    @index.reset()

    {q,filter} = @getParams()

    query = "/search.html?q=#{q}"

    query += "&filter=#{filter}" if filter?.length > 0

    if (q.length >= @minSearchLength) || bypassMinLengthCheck
      Application.request(query).andUpdate(@searchResultsElement())
      @lastQuery = query
    else
      @searchResultsElement().empty()

  getParams: ()->
    filter: @searchFilter
    q: @$('input').val()

  searchResultsElement: ()->
    if @$(".search-results").length is 0
      @$el.append("<div class='search-results' />")

    @$('.search-results').empty()

  render: ()->
    @setElement $('.navbar #sitewide-search')
    @


Application.SitewideSearch.renderSingleton = ()->
  @siteWideSearch?.remove()
  @siteWideSearch = new Application.SitewideSearch()

Application.on "after:boot", Application.SitewideSearch.renderSingleton, @

Application.IndexTracker = Backbone.Model.extend

  defaults:
    index: -1

  value: ()->
    parseInt @get("index")

  reset: ()->
    @set("index", -1, silent: true)

  increment: (maxValue)->
    current = @get("index")
    current = current + 1
    current = maxValue if current > maxValue

    @set("index", current)

    current

  decrement: (minValue=0)->
    current = @get("index")
    current = current - 1
    current = 0 unless current <= minValue

    @set("index", current)

    current


