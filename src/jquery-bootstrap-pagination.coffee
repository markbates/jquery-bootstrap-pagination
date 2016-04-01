(($) ->

  # the jQuery function that starts it all:
  ###
  $(".my-pagination").pagination();

  $(".my-pagination").pagination({total_pages: 3, current_page: 1});

  $(".my-pagination").pagination({
    total_pages: 3,
    current_page: 1,
    callback: function(event, page) {
      alert("Clicked: " + page);
    }
  });
  ###
  $.fn.pagination = (options) ->
    return @each ->
      new PaginationView($(@), options).render()

  class PaginationView

    constructor: (@el, options) ->
      defaults =
        # what is the current page:
        current_page: 1
        # how many pages are there total:
        total_pages: 1
        # change text of the 'next' link,
        # set to false for no next link:
        next: "&gt;"
        # change text of the 'previous' link,
        # set to false for no previous link:
        prev: "&lt;"
        # change text of the 'first' link,
        # set to false for no first link:
        first: false
        # change text of the 'last' link,
        # set to false for no last link:
        last: false
        # how many links before truncation happens:
        display_max: 8
        # render nothing if there is only 1 page:
        ignore_single_page: true
        # disable turbolinks
        no_turbolink: false

      # merge defaults with passed in options:
      @settings = $.extend(defaults, options)
      @settings.total_pages = Math.max(1, @settings.total_pages)

      # add a click handler event to the view:
      if $(document).on
        $(@el).on("click", "a", @clicked)
      else
        $("a", @el).live("click", @clicked)

      # add this view to the original element
      # so it can be accessed later:
      @el.data("paginationView", @)

    # builds an array containing all of the links
    # for the pagination element:
    buildLinks: =>
      current_page = @settings.current_page
      links = []
      # if @settings.first then add a link
      # back to the first page:
      if @settings.first
        links.push @buildLi(1, @settings.first)
      # if @settings.prev then add a link
      # back to the previous page:
      if @settings.prev
        links.push @buildLi((current_page - 1), @settings.prev)
      # create links for all of the pages:
      for page in @pages()
        links.push @buildLi(page, page)
      # if @settings.next then add a link
      # to the next page:
      if @settings.next
        links.push @buildLi((current_page + 1), @settings.next)
      # if @settings.last then add a link
      # to the last page:
      if @settings.last
        links.push @buildLi(@settings.total_pages, @settings.last)
      return links

    # build the `li` element for the link:
    buildLi: (page, text = page) =>
      "<li>#{@buildLink(page, text)}</li>"

    # build the link element
    buildLink: (page, text = page) =>
      if @settings.no_turbolink
        data_attr = " data-no-turbolink='1'"
      else
        data_attr = ""
      "<a href='#' data-page='#{page}'#{data_attr}>#{text}</a>"

    # returns an array of all of the 'pages' in the pagination:
    pages: =>
      total_pages = @settings.total_pages
      current_page = @settings.current_page
      pages = []
      max = @settings.display_max
      # if there are more than 10 total pages let's build the list:
      if total_pages > 10
        # add page 1:
        pages.push 1
        # add truncation if the current page is greater than
        # the maximum pages minus one:
        pages.push ".." if current_page > max - 1
        # if this is the last page then add the last set of pages:
        if current_page is total_pages
          pages.push page for page in [(total_pages - max)..total_pages]
        # if the total pages minus the current page less than the maximum
        # page minus one:
        if total_pages - current_page < max - 1
          pages.push page for page in [(total_pages - max)..total_pages]
        # else if the current page is greater than the maximum display then
        # show pages on both side of the current page:
        else if current_page > max - 1
          buf = Math.ceil(max / 2)
          pages.push page for page in [(current_page - buf)..(current_page + buf)]
        # else if the current page is less than or equal to the sub max then only
        # show from 2 to the max page.
        else if current_page <= max - 1
          pages.push page for page in [2..max]

        # make sure they're all unique pages:
        pages = $.grep pages, (v, k) ->
          return $.inArray(v ,pages) is k

        # if the pages array does not contain the last page:
        unless total_pages in pages
          # add truncation if there are more pages:
          unless (total_pages - current_page) < max - 1
            pages.push ".."
          # add the last page to the list of pages:
          pages.push total_pages
      # less than 10 total pages, so just add them all:
      else
        pages.push page for page in [1..total_pages]
      return pages

    # renders the pagination links to the element. the
    # element is cleared of all of it's HTML in this process.
    render: =>
      @el.html("")
      # if there is only 1 page and the 'ignore_single_page' flag
      # is 'true' then render nothing.
      if @settings.total_pages is 1 and @settings.ignore_single_page
        return
      # render all of the pages:
      html = ["<div class='jquery-bootstrap-pagination'>"]
      html.push "<ul class='pagination'>"
      for link in @buildLinks()
        html.push link
      html.push "</ul>"
      html.push "</div>"
      @el.html(html.join("\n"))
      # add the 'active' class to the current page's li:
      $("[data-page=#{@settings.current_page}]", @el).closest("li").addClass("active")
      # add the 'disabled' class to any truncation li's:
      $("[data-page='..']", @el).closest("li").addClass("disabled")
      # add the 'disabled' class to the 'previous' link if the page is 0:
      $("[data-page='0']", @el).closest("li").addClass("disabled")
      # add the 'disabled' class to the 'next' link if it's out of bounds:
      $("[data-page='#{@settings.total_pages + 1}']", @el).closest("li").addClass("disabled")
      # add the 'disabled' class to the 'first' li if you're on the first page:
      if @settings.current_page is 1 and @settings.first
        $("li:first", @el).removeClass("active").addClass("disabled")
      # add the 'disabled' class to the 'last' li if you're on the last page:
      if @settings.current_page is @settings.total_pages and @settings.last
        $("li:last", @el).removeClass("active").addClass("disabled")

    isValidPage: (page) =>
      page > 0 and \
        page isnt @settings.current_page and \
        page <= @settings.total_pages

    # called when a link is clicked in the pagination list:
    clicked: (event) =>
      event.preventDefault()
      page = parseInt($(event.target).attr("data-page"))
      return unless @isValidPage(page)
      # if there is a callback registered, then call it
      # passing the original event and the page number that was clicked:
      if @settings.callback?
        @settings.callback(event, page)
      @change(page)

    change: (page) =>
      page = parseInt(page)
      return unless @isValidPage(page)
      # set the current page to the clicked page:
      @settings.current_page = page
      # re-render the pagination information to reflect the newly
      # current page:
      @render()

)(jQuery)
