describe "pagination", ->
  
  beforeEach ->
    $("#jasmine").remove()
    $("body").append("<div id='jasmine'></div>")
    @page = $("#jasmine")
    @view = @page.pagination(total: 60, total_pages: 3, next: null, prev: null).data("paginationView")

  describe "buildLinks", ->
    
    it "returns the correct links for the pages", ->
      links = @view.buildLinks()
      expect(links[0]).toEqual("<li><a href='#' data-page='1'>1</a></li>")
      expect(links[1]).toEqual("<li><a href='#' data-page='2'>2</a></li>")
      expect(links[2]).toEqual("<li><a href='#' data-page='3'>3</a></li>")

    it "adds a first and last link", ->
      @view.settings.first = "first"
      @view.settings.last = "last"
      links = @view.buildLinks()
      expect(links[0]).toEqual("<li><a href='#' data-page='1'>first</a></li>")
      expect(links[1]).toEqual("<li><a href='#' data-page='1'>1</a></li>")
      expect(links[2]).toEqual("<li><a href='#' data-page='2'>2</a></li>")
      expect(links[3]).toEqual("<li><a href='#' data-page='3'>3</a></li>")
      expect(links[4]).toEqual("<li><a href='#' data-page='3'>last</a></li>")

    it "truncates links if there are too many", ->
      @view.settings.total_pages = 50
      @view.settings.current_page = 2
      links = @view.buildLinks()
      expect(links.length).toEqual(10)
      expect(links[0]).toEqual("<li><a href='#' data-page='1'>1</a></li>")
      expect(links[1]).toEqual("<li><a href='#' data-page='2'>2</a></li>")
      expect(links[2]).toEqual("<li><a href='#' data-page='3'>3</a></li>")
      expect(links[3]).toEqual("<li><a href='#' data-page='4'>4</a></li>")
      expect(links[4]).toEqual("<li><a href='#' data-page='5'>5</a></li>")
      expect(links[5]).toEqual("<li><a href='#' data-page='6'>6</a></li>")
      expect(links[6]).toEqual("<li><a href='#' data-page='7'>7</a></li>")
      expect(links[7]).toEqual("<li><a href='#' data-page='8'>8</a></li>")
      expect(links[8]).toEqual("<li><a href='#' data-page='..'>..</a></li>")
      expect(links[9]).toEqual("<li><a href='#' data-page='50'>50</a></li>")

    it "shows a max number of links", ->
      @view.settings.total_pages = 50
      @view.settings.current_page = 2
      @view.settings.display_max = 12
      links = @view.buildLinks()
      expect(links.length).toEqual(14)
      expect(links[0]).toEqual("<li><a href='#' data-page='1'>1</a></li>")
      expect(links[1]).toEqual("<li><a href='#' data-page='2'>2</a></li>")
      expect(links[2]).toEqual("<li><a href='#' data-page='3'>3</a></li>")
      expect(links[3]).toEqual("<li><a href='#' data-page='4'>4</a></li>")
      expect(links[4]).toEqual("<li><a href='#' data-page='5'>5</a></li>")
      expect(links[5]).toEqual("<li><a href='#' data-page='6'>6</a></li>")
      expect(links[6]).toEqual("<li><a href='#' data-page='7'>7</a></li>")
      expect(links[7]).toEqual("<li><a href='#' data-page='8'>8</a></li>")
      expect(links[8]).toEqual("<li><a href='#' data-page='9'>9</a></li>")
      expect(links[9]).toEqual("<li><a href='#' data-page='10'>10</a></li>")
      expect(links[10]).toEqual("<li><a href='#' data-page='11'>11</a></li>")
      expect(links[11]).toEqual("<li><a href='#' data-page='12'>12</a></li>")
      expect(links[12]).toEqual("<li><a href='#' data-page='..'>..</a></li>")
      expect(links[13]).toEqual("<li><a href='#' data-page='50'>50</a></li>")

    it "shows next if there are next pages", ->
      @view.settings.next = "next"
      links = @view.buildLinks()
      expect(links[0]).toEqual("<li><a href='#' data-page='1'>1</a></li>")
      expect(links[1]).toEqual("<li><a href='#' data-page='2'>2</a></li>")
      expect(links[2]).toEqual("<li><a href='#' data-page='3'>3</a></li>")
      expect(links[3]).toEqual("<li><a href='#' data-page='2'>next</a></li>")

    it "shows prev if there are prev pages", ->
      @view.settings.prev = "prev"
      @view.settings.current_page = 2
      links = @view.buildLinks()
      expect(links[0]).toEqual("<li><a href='#' data-page='1'>prev</a></li>")
      expect(links[1]).toEqual("<li><a href='#' data-page='1'>1</a></li>")
      expect(links[2]).toEqual("<li><a href='#' data-page='2'>2</a></li>")
      expect(links[3]).toEqual("<li><a href='#' data-page='3'>3</a></li>")
      
    it "disables turbolinks (if requested)", ->
      @view.settings.prev = "prev"
      @view.settings.current_page = 2
      @view.settings.no_turbolink = true
      links = @view.buildLinks()
      expect(links[0]).toEqual("<li><a href='#' data-page='1' data-no-turbolink='1'>prev</a></li>")

  describe "render", ->
    
    it "renders the pagination HTML to the el", ->
      @view.render()
      expect(@page.html()).toEqual("""
        <div class="jquery-bootstrap-pagination pagination">
        <ul>
        <li class="active"><a href="#" data-page="1">1</a></li>
        <li><a href="#" data-page="2">2</a></li>
        <li><a href="#" data-page="3">3</a></li>
        </ul>
        </div>
      """)

    it "renders nothing if there is only 1 page", ->
      @view.settings.total_pages = 1
      @view.settings.current_page = 1
      @view.render()
      expect(@page.html()).toEqual("")

    it "adds 'active' to the current page", ->
      @view.settings.current_page = 2
      @view.render()
      expect(@page.html()).toEqual("""
        <div class="jquery-bootstrap-pagination pagination">
        <ul>
        <li><a href="#" data-page="1">1</a></li>
        <li class="active"><a href="#" data-page="2">2</a></li>
        <li><a href="#" data-page="3">3</a></li>
        </ul>
        </div>
      """)

    it "disables the first link if on page 1", ->
      @view.settings.first = "first"
      @view.settings.last = "last"
      @view.settings.current_page = 1
      @view.render()
      expect(@page.html()).toEqual("""
        <div class="jquery-bootstrap-pagination pagination">
        <ul>
        <li class="disabled"><a href="#" data-page="1">first</a></li>
        <li class="active"><a href="#" data-page="1">1</a></li>
        <li><a href="#" data-page="2">2</a></li>
        <li><a href="#" data-page="3">3</a></li>
        <li><a href="#" data-page="3">last</a></li>
        </ul>
        </div>
      """)

    it "disables the last link if on the last page", ->
      @view.settings.first = "first"
      @view.settings.last = "last"
      @view.settings.current_page = @view.settings.total_pages
      @view.render()
      expect(@page.html()).toEqual("""
        <div class="jquery-bootstrap-pagination pagination">
        <ul>
        <li><a href="#" data-page="1">first</a></li>
        <li><a href="#" data-page="1">1</a></li>
        <li><a href="#" data-page="2">2</a></li>
        <li class="active"><a href="#" data-page="3">3</a></li>
        <li class="disabled"><a href="#" data-page="3">last</a></li>
        </ul>
        </div>
      """)

    it "disables truncated pages", ->
      @view.settings.total_pages = 50
      @view.settings.current_page = 2
      @view.render()
      expect(@page.html()).toEqual("""
        <div class="jquery-bootstrap-pagination pagination">
        <ul>
        <li><a href="#" data-page="1">1</a></li>
        <li class="active"><a href="#" data-page="2">2</a></li>
        <li><a href="#" data-page="3">3</a></li>
        <li><a href="#" data-page="4">4</a></li>
        <li><a href="#" data-page="5">5</a></li>
        <li><a href="#" data-page="6">6</a></li>
        <li><a href="#" data-page="7">7</a></li>
        <li><a href="#" data-page="8">8</a></li>
        <li class="disabled"><a href="#" data-page="..">..</a></li>
        <li><a href="#" data-page="50">50</a></li>
        </ul>
        </div>
      """)

    it "disables truncated pages", ->
      @view.settings.total_pages = 50
      @view.settings.current_page = 2
      @view.render()
      expect(@page.html()).toEqual("""
        <div class="jquery-bootstrap-pagination pagination">
        <ul>
        <li><a href="#" data-page="1">1</a></li>
        <li class="active"><a href="#" data-page="2">2</a></li>
        <li><a href="#" data-page="3">3</a></li>
        <li><a href="#" data-page="4">4</a></li>
        <li><a href="#" data-page="5">5</a></li>
        <li><a href="#" data-page="6">6</a></li>
        <li><a href="#" data-page="7">7</a></li>
        <li><a href="#" data-page="8">8</a></li>
        <li class="disabled"><a href="#" data-page="..">..</a></li>
        <li><a href="#" data-page="50">50</a></li>
        </ul>
        </div>
      """)

    it "paints the correct range", ->
      @view.settings.total_pages = 50
      @view.settings.current_page = 8
      @view.render()
      expect(@page.html()).toEqual("""
        <div class="jquery-bootstrap-pagination pagination">
        <ul>
        <li><a href="#" data-page="1">1</a></li>
        <li class="disabled"><a href="#" data-page="..">..</a></li>
        <li><a href="#" data-page="4">4</a></li>
        <li><a href="#" data-page="5">5</a></li>
        <li><a href="#" data-page="6">6</a></li>
        <li><a href="#" data-page="7">7</a></li>
        <li class="active"><a href="#" data-page="8">8</a></li>
        <li><a href="#" data-page="9">9</a></li>
        <li><a href="#" data-page="10">10</a></li>
        <li><a href="#" data-page="11">11</a></li>
        <li><a href="#" data-page="12">12</a></li>
        <li class="disabled"><a href="#" data-page="..">..</a></li>
        <li><a href="#" data-page="50">50</a></li>
        </ul>
        </div>
      """)

  describe "clicked", ->
    
    it "re-renders the pagination links", ->
      @view.settings.total_pages = 50
      @view.settings.current_page = 2
      @view.render()
      expect(@page.html()).toEqual("""
        <div class="jquery-bootstrap-pagination pagination">
        <ul>
        <li><a href="#" data-page="1">1</a></li>
        <li class="active"><a href="#" data-page="2">2</a></li>
        <li><a href="#" data-page="3">3</a></li>
        <li><a href="#" data-page="4">4</a></li>
        <li><a href="#" data-page="5">5</a></li>
        <li><a href="#" data-page="6">6</a></li>
        <li><a href="#" data-page="7">7</a></li>
        <li><a href="#" data-page="8">8</a></li>
        <li class="disabled"><a href="#" data-page="..">..</a></li>
        <li><a href="#" data-page="50">50</a></li>
        </ul>
        </div>
      """)
      $("[data-page=8]", @view.el).click()
      @view.render()
      expect(@page.html()).toEqual("""
        <div class="jquery-bootstrap-pagination pagination">
        <ul>
        <li><a href="#" data-page="1">1</a></li>
        <li class="disabled"><a href="#" data-page="..">..</a></li>
        <li><a href="#" data-page="4">4</a></li>
        <li><a href="#" data-page="5">5</a></li>
        <li><a href="#" data-page="6">6</a></li>
        <li><a href="#" data-page="7">7</a></li>
        <li class="active"><a href="#" data-page="8">8</a></li>
        <li><a href="#" data-page="9">9</a></li>
        <li><a href="#" data-page="10">10</a></li>
        <li><a href="#" data-page="11">11</a></li>
        <li><a href="#" data-page="12">12</a></li>
        <li class="disabled"><a href="#" data-page="..">..</a></li>
        <li><a href="#" data-page="50">50</a></li>
        </ul>
        </div>
      """)


  describe "change", ->

    it "re-renders the pagination links", ->
      @view.settings.total_pages = 50
      @view.settings.current_page = 2
      @view.render()
      expect(@page.html()).toEqual("""
        <div class="jquery-bootstrap-pagination pagination">
        <ul>
        <li><a href="#" data-page="1">1</a></li>
        <li class="active"><a href="#" data-page="2">2</a></li>
        <li><a href="#" data-page="3">3</a></li>
        <li><a href="#" data-page="4">4</a></li>
        <li><a href="#" data-page="5">5</a></li>
        <li><a href="#" data-page="6">6</a></li>
        <li><a href="#" data-page="7">7</a></li>
        <li><a href="#" data-page="8">8</a></li>
        <li class="disabled"><a href="#" data-page="..">..</a></li>
        <li><a href="#" data-page="50">50</a></li>
        </ul>
        </div>
      """)
      @view.change(8)
      expect(@page.html()).toEqual("""
        <div class="jquery-bootstrap-pagination pagination">
        <ul>
        <li><a href="#" data-page="1">1</a></li>
        <li class="disabled"><a href="#" data-page="..">..</a></li>
        <li><a href="#" data-page="4">4</a></li>
        <li><a href="#" data-page="5">5</a></li>
        <li><a href="#" data-page="6">6</a></li>
        <li><a href="#" data-page="7">7</a></li>
        <li class="active"><a href="#" data-page="8">8</a></li>
        <li><a href="#" data-page="9">9</a></li>
        <li><a href="#" data-page="10">10</a></li>
        <li><a href="#" data-page="11">11</a></li>
        <li><a href="#" data-page="12">12</a></li>
        <li class="disabled"><a href="#" data-page="..">..</a></li>
        <li><a href="#" data-page="50">50</a></li>
        </ul>
        </div>
      """)

    it "doesn't re-render if page > total_pages (invalid)", ->
      @view.settings.total_pages = 50
      @view.settings.current_page = 2
      @view.render()
      expect(@page.html()).toEqual("""
        <div class="jquery-bootstrap-pagination pagination">
        <ul>
        <li><a href="#" data-page="1">1</a></li>
        <li class="active"><a href="#" data-page="2">2</a></li>
        <li><a href="#" data-page="3">3</a></li>
        <li><a href="#" data-page="4">4</a></li>
        <li><a href="#" data-page="5">5</a></li>
        <li><a href="#" data-page="6">6</a></li>
        <li><a href="#" data-page="7">7</a></li>
        <li><a href="#" data-page="8">8</a></li>
        <li class="disabled"><a href="#" data-page="..">..</a></li>
        <li><a href="#" data-page="50">50</a></li>
        </ul>
        </div>
      """)
      @view.change(51)
      expect(@page.html()).toEqual("""
        <div class="jquery-bootstrap-pagination pagination">
        <ul>
        <li><a href="#" data-page="1">1</a></li>
        <li class="active"><a href="#" data-page="2">2</a></li>
        <li><a href="#" data-page="3">3</a></li>
        <li><a href="#" data-page="4">4</a></li>
        <li><a href="#" data-page="5">5</a></li>
        <li><a href="#" data-page="6">6</a></li>
        <li><a href="#" data-page="7">7</a></li>
        <li><a href="#" data-page="8">8</a></li>
        <li class="disabled"><a href="#" data-page="..">..</a></li>
        <li><a href="#" data-page="50">50</a></li>
        </ul>
        </div>
      """)

    it "doesn't re-render if page < 1 (invalid)", ->
      @view.settings.total_pages = 50
      @view.settings.current_page = 2
      @view.render()
      expect(@page.html()).toEqual("""
        <div class="jquery-bootstrap-pagination pagination">
        <ul>
        <li><a href="#" data-page="1">1</a></li>
        <li class="active"><a href="#" data-page="2">2</a></li>
        <li><a href="#" data-page="3">3</a></li>
        <li><a href="#" data-page="4">4</a></li>
        <li><a href="#" data-page="5">5</a></li>
        <li><a href="#" data-page="6">6</a></li>
        <li><a href="#" data-page="7">7</a></li>
        <li><a href="#" data-page="8">8</a></li>
        <li class="disabled"><a href="#" data-page="..">..</a></li>
        <li><a href="#" data-page="50">50</a></li>
        </ul>
        </div>
      """)
      @view.change(0)
      expect(@page.html()).toEqual("""
        <div class="jquery-bootstrap-pagination pagination">
        <ul>
        <li><a href="#" data-page="1">1</a></li>
        <li class="active"><a href="#" data-page="2">2</a></li>
        <li><a href="#" data-page="3">3</a></li>
        <li><a href="#" data-page="4">4</a></li>
        <li><a href="#" data-page="5">5</a></li>
        <li><a href="#" data-page="6">6</a></li>
        <li><a href="#" data-page="7">7</a></li>
        <li><a href="#" data-page="8">8</a></li>
        <li class="disabled"><a href="#" data-page="..">..</a></li>
        <li><a href="#" data-page="50">50</a></li>
        </ul>
        </div>
      """)

    it "doesn't re-render if there's no change in page", ->
      @view.settings.total_pages = 50
      @view.settings.current_page = 2
      @view.render()
      expect(@page.html()).toEqual("""
        <div class="jquery-bootstrap-pagination pagination">
        <ul>
        <li><a href="#" data-page="1">1</a></li>
        <li class="active"><a href="#" data-page="2">2</a></li>
        <li><a href="#" data-page="3">3</a></li>
        <li><a href="#" data-page="4">4</a></li>
        <li><a href="#" data-page="5">5</a></li>
        <li><a href="#" data-page="6">6</a></li>
        <li><a href="#" data-page="7">7</a></li>
        <li><a href="#" data-page="8">8</a></li>
        <li class="disabled"><a href="#" data-page="..">..</a></li>
        <li><a href="#" data-page="50">50</a></li>
        </ul>
        </div>
      """)
      @view.change(2)
      expect(@page.html()).toEqual("""
        <div class="jquery-bootstrap-pagination pagination">
        <ul>
        <li><a href="#" data-page="1">1</a></li>
        <li class="active"><a href="#" data-page="2">2</a></li>
        <li><a href="#" data-page="3">3</a></li>
        <li><a href="#" data-page="4">4</a></li>
        <li><a href="#" data-page="5">5</a></li>
        <li><a href="#" data-page="6">6</a></li>
        <li><a href="#" data-page="7">7</a></li>
        <li><a href="#" data-page="8">8</a></li>
        <li class="disabled"><a href="#" data-page="..">..</a></li>
        <li><a href="#" data-page="50">50</a></li>
        </ul>
        </div>
      """)

  describe "pages", ->

    describe "less than or equal to 10 pages", ->

      beforeEach ->
        @view.settings.total_pages = 10

      it "handles the first page", ->
        @view.settings.current_page = 1
        pages = @view.pages()
        expect(pages).toEqual([1,2,3,4,5,6,7,8,9,10])

      it "handles a middle page", ->
        @view.settings.current_page = 3
        pages = @view.pages()
        expect(pages).toEqual([1,2,3,4,5,6,7,8,9,10])

      it "handles the last page", ->
        @view.settings.current_page = 10
        pages = @view.pages()
        expect(pages).toEqual([1,2,3,4,5,6,7,8,9,10])

    describe "greater than 10 pages", ->
      
      beforeEach ->
        @view.settings.total_pages = 50  

      it "handles the first page", ->
        @view.settings.current_page = 1
        pages = @view.pages()
        expect(pages).toEqual([1,2,3,4,5,6,7,8, "..", 50])
      
      it "handles the last page", ->
        @view.settings.current_page = 50
        pages = @view.pages()
        expect(pages).toEqual([1, "..", 42,43,44,45,46,47,48,49,50])

      it "handles page 49", ->
        @view.settings.current_page = 49
        pages = @view.pages()
        expect(pages).toEqual([1, "..", 42,43,44,45,46,47,48,49,50])

      it "handles near the last page", ->
        @view.settings.current_page = 47
        pages = @view.pages()
        expect(pages).toEqual([1, "..", 42,43,44,45,46,47,48,49,50])

      it "handles page 44", ->
        @view.settings.current_page = 44
        pages = @view.pages()
        expect(pages).toEqual([1, "..", 42,43,44,45,46,47,48,49,50])

      it "handles page 43", ->
        @view.settings.current_page = 42
        pages = @view.pages()
        expect(pages).toEqual([1, "..", 38,39,40,41,42,43,44,45,46,"..",50])

      it "handles page 7", ->
        @view.settings.current_page = 7
        pages = @view.pages()
        expect(pages).toEqual([1, 2, 3, 4, 5, 6, 7, 8, '..', 50])

      it "handles page 9", ->
        @view.settings.current_page = 9
        pages = @view.pages()
        expect(pages).toEqual([1,"..",5,6,7,8,9,10,11,12,13, "..", 50])

      it "handles a middle page", ->
        @view.settings.current_page = 25
        pages = @view.pages()
        expect(pages).toEqual([1, "..", 21,22,23,24,25,26,27,28,29, "..", 50])