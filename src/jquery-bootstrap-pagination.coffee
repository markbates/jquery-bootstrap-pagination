(($) ->

  class PaginationView

    constructor: (@el, options) ->
      defaults =
        current_page: 1
        total_pages: 1
        next: "&gt;"
        prev: "&lt;"
      @settings = $.extend(defaults, options)
      # console?.log """@settings""", @settings
      $("a", @el).live "click", @clicked
      @el.data("paginationView", @)

    buildLinks: =>
      current_page = @settings.current_page
      links = []
      if @settings.prev
        links.push @buildLi((current_page - 1), @settings.prev)
      for page in @pages()
        links.push @buildLi(page, page)
      if @settings.next
        links.push @buildLi((current_page + 1), @settings.next)
      return links

    buildLi: (page, text = page)=>
      "<li><a href='#' data-page='#{page}'>#{text}</a></li>"

    pages: =>
      total_pages = @settings.total_pages
      current_page = @settings.current_page
      pages = []
      if total_pages > 10
        pages.push 1
        pages.push ".." if current_page > 7
        if current_page is total_pages
          pages.push page for page in [(total_pages - 8)..total_pages]
        if total_pages - current_page < 7
          pages.push page for page in [(total_pages - 8)..total_pages]
        else if current_page > 7
          pages.push page for page in [(current_page - 4)..(current_page + 4)]
        else if current_page <= 7
          pages.push page for page in [2..8]

        # make sure they're all unique pages:
        pages = $.grep pages, (v, k) ->
          return $.inArray(v ,pages) is k
        unless total_pages in pages
          pages.push ".." unless (total_pages - current_page) < 7
          pages.push total_pages
      else
        pages.push page for page in [1..total_pages]
      return pages

    render: =>
      html = ["<div class='jquery-bootstrap-pagination'>"]
      html.push "<ul>"
      for link in @buildLinks()
        html.push link
      html.push "</ul>"
      html.push "</div>"
      @el.html(html.join("\n"))
      $("[data-page=#{@settings.current_page}]", @el).closest("li").addClass("active")
      $("[data-page='..']", @el).closest("li").addClass("disabled")
      $("[data-page='0']", @el).closest("li").addClass("disabled")
      $("[data-page='#{@settings.total_pages + 1}']", @el).closest("li").addClass("disabled")

    clicked: (event) =>
      page = $(event.target).attr("data-page")
      if @settings.callback?
        @settings.callback(event, page)
      @settings.current_page = parseInt(page)
      @render()

  $.fn.pagination = (options) ->
    return @each ->
      new PaginationView($(@), options).render()

)(jQuery)