// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

import "foundation-sites"
require("src/application")

function greaterThanValidator($el, required, parent) {
  if (!required) return true;
  var from = $el.data('greater-than');
  var to = $el.val();

  return (parseInt(to) > parseInt(from));
};

function toggleHiddenField(e, speed = 500) {
  var true_ids = e.data('toggle-true') ? "#" + e.data('toggle-true').split(' ').join(', #') : null;
  var false_ids = e.data('toggle-false') ? "#" + e.data('toggle-false').split(' ').join(', #') : null;
  
  toggleField(true_ids, e.is(":checked"), speed)
  toggleField(false_ids, !e.is(":checked"), speed)
}

function toggleField(ids, show, global_speed) {
  $(ids).each(function() {
    var speed = $(this).is('label') ? 0 : global_speed;
    console.log(speed)

    if (show) {
      speed === 0 ? $(this).show() : $(this).slideDown(speed)
      $(this).find('input, select, textarea').removeAttr('data-abide-ignore')
    } else {
      speed === 0 ? $(this).hide() : $(this).slideUp(speed)
      $(this).find('input, select, textarea').attr('data-abide-ignore', 'true')
    }
  });
}

$(document).on('turbolinks:load', function() {
  Foundation.Abide.defaults.validators['greater_than'] = greaterThanValidator;

  $(document).foundation()

  $('input[type="checkbox"].toggle-fields').each(function() {
    toggleHiddenField($(this), 0);
  });

  $('body').on('change', 'input[type="checkbox"].toggle-fields', function() {
    toggleHiddenField($(this));
  });
});

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
