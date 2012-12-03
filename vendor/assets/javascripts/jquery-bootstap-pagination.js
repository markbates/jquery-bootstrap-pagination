(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  (function($) {
    var PaginationView;
    PaginationView = (function() {

      function PaginationView(el, options) {
        var defaults;
        this.el = el;
        this.clicked = __bind(this.clicked, this);

        this.render = __bind(this.render, this);

        this.pages = __bind(this.pages, this);

        this.buildLi = __bind(this.buildLi, this);

        this.buildLinks = __bind(this.buildLinks, this);

        defaults = {
          current_page: 1,
          total_pages: 1
        };
        this.settings = $.extend(defaults, options);
        $("a", this.el).live("click", this.clicked);
        this.el.data("paginationView", this);
      }

      PaginationView.prototype.buildLinks = function() {
        var current_page, links, page, _i, _len, _ref;
        current_page = this.settings.current_page;
        links = [];
        if ((this.settings.prev != null) && current_page !== 1) {
          links.push(this.buildLi(current_page - 1, this.settings.prev));
        }
        _ref = this.pages();
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          page = _ref[_i];
          links.push(this.buildLi(page, page));
        }
        if ((this.settings.next != null) && current_page !== this.settings.total_pages) {
          links.push(this.buildLi(current_page + 1, this.settings.next));
        }
        return links;
      };

      PaginationView.prototype.buildLi = function(page, text) {
        if (text == null) {
          text = page;
        }
        return "<li><a href='#' data-page='" + page + "'>" + text + "</a></li>";
      };

      PaginationView.prototype.pages = function() {
        var current_page, page, pages, total_pages, _i, _j, _k, _l, _m, _ref, _ref1, _ref2, _ref3;
        total_pages = this.settings.total_pages;
        current_page = this.settings.current_page;
        pages = [];
        if (total_pages > 10) {
          pages.push(1);
          if (current_page > 7) {
            pages.push("..");
          }
          if (current_page === total_pages) {
            for (page = _i = _ref = total_pages - 8; _ref <= total_pages ? _i <= total_pages : _i >= total_pages; page = _ref <= total_pages ? ++_i : --_i) {
              pages.push(page);
            }
          }
          if (total_pages - current_page < 7) {
            for (page = _j = _ref1 = total_pages - 8; _ref1 <= total_pages ? _j <= total_pages : _j >= total_pages; page = _ref1 <= total_pages ? ++_j : --_j) {
              pages.push(page);
            }
          } else if (current_page > 7) {
            for (page = _k = _ref2 = current_page - 4, _ref3 = current_page + 4; _ref2 <= _ref3 ? _k <= _ref3 : _k >= _ref3; page = _ref2 <= _ref3 ? ++_k : --_k) {
              pages.push(page);
            }
          } else if (current_page <= 7) {
            for (page = _l = 2; _l <= 8; page = ++_l) {
              pages.push(page);
            }
          }
          pages = $.grep(pages, function(v, k) {
            return $.inArray(v, pages) === k;
          });
          if (__indexOf.call(pages, total_pages) < 0) {
            if (!((total_pages - current_page) < 7)) {
              pages.push("..");
            }
            pages.push(total_pages);
          }
        } else {
          for (page = _m = 1; 1 <= total_pages ? _m <= total_pages : _m >= total_pages; page = 1 <= total_pages ? ++_m : --_m) {
            pages.push(page);
          }
        }
        return pages;
      };

      PaginationView.prototype.render = function() {
        var html, link, _i, _len, _ref;
        html = ["<div class='pagination'>"];
        html.push("<ul>");
        _ref = this.buildLinks();
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          link = _ref[_i];
          html.push(link);
        }
        html.push("</ul>");
        html.push("</div>");
        this.el.html(html.join("\n"));
        $("[data-page=" + this.settings.current_page + "]", this.el).closest("li").addClass("active");
        return $("[data-page='..']", this.el).closest("li").addClass("disabled");
      };

      PaginationView.prototype.clicked = function(event) {
        var page;
        page = $(event.target).attr("data-page");
        if (this.settings.callback != null) {
          this.settings.callback(event, page);
        }
        this.settings.current_page = parseInt(page);
        return this.render();
      };

      return PaginationView;

    })();
    return $.fn.pagination = function(options) {
      return this.each(function() {
        return new PaginationView($(this), options);
      });
    };
  })(jQuery);

}).call(this);
