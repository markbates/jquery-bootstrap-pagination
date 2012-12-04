# jQuery Bootstrap Pagination

A simple, full-featured, pagination system for [jQuery](http://jquery.com/) that outputs [Twitter Bootstrap](http://twitter.github.com/bootstrap/) marked up pagination links. Of course, there's no reason you need to use this with Bootstrap, the HTML output is very clean.

## Installation

The library can be used in CoffeeScript, JavaScript, and Rails applications very easily.

### Standalone

#### CoffeeScript

Use the `src/jquery-bootstrap-pagination.coffee` file.

#### JavaScript

Use the `vendor/assets/javascripts/jquery-bootstrap-pagination.js` file. This file is auto generated from the CoffeeScript file.

### Rails 3.x

Add this line to your application's Gemfile:

``` ruby
gem 'jquery-bootstrap-pagination'
```

And then execute:

```
$ bundle
```

Add it to your `application.js` file:

``` javascript
//= require jquery-bootstrap-pagination
```

## Usage

### CoffeeScript
``` coffeescript
# Basic usage:
$("#my-pagination-section").pagination()

# With options:
$("#my-pagination-section").pagination
  total_pages: 10
  current_page: 2
  callback: (event, page) ->
    alert("Page #{page} was clicked!")

# Retrieve the underlying PaginationView:
$("#my-pagination-section").data("paginationView")
```

### JavaScript:
``` javascript
// Basic usage:
$("#my-pagination-section").pagination();

// With options:
$("#my-pagination-section").pagination({
  total_pages: 10,
  current_page: 2,
  callback: function(event, page) {
    return alert("Page " + page + " was clicked!");
  }
});

// Retrieve the underlying PaginationView:
$("#my-pagination-section").data("paginationView");
```

### Options and Defaults:
``` coffeescript
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
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write/Run tests (`bundle exec rake`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
