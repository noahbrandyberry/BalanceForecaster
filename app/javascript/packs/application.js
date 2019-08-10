// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

import "foundation-sites"
import "tooltipster"
require("src/application")

window.$ = $
window.jQuery = $

function greaterThanValidator($el, required, parent) {
  if (!required) return true;
  var from = $el.data('greater-than');
  var to = $el.val();

  return (parseInt(to) > parseInt(from));
};

function toggleHiddenField(e, speed = 500) {
  if (e.is('select')) {
    var toggleable_fields = {};
    var data = e.data();

    for (var property in data) {
      if (data.hasOwnProperty(property) && 
         property.startsWith('toggle')) {
         toggleable_fields[property.substr(6).replace( /([a-z])([A-Z])/g, '$1-$2' ).toLowerCase()] = data[property];
      }
    }

    var true_ids = toggleable_fields[e.val()]
    delete toggleable_fields[e.val()]
    var false_ids = Object.values(toggleable_fields).join(' ');
    
    true_ids = true_ids ? "#" + true_ids.split(' ').join(', #') : null;
    false_ids = false_ids ? "#" + false_ids.split(' ').join(', #') : null;

    toggleField(true_ids, true, speed)
    toggleField(false_ids, false, speed)
  } else if (e.is('input[type="checkbox"]')) {
    var true_ids = e.data('toggle-true') ? "#" + e.data('toggle-true').split(' ').join(', #') : null;
    var false_ids = e.data('toggle-false') ? "#" + e.data('toggle-false').split(' ').join(', #') : null;
    
    toggleField(true_ids, e.is(":checked"), speed)
    toggleField(false_ids, !e.is(":checked"), speed)
  }
}

function toggleField(ids, show, global_speed) {
  $(ids).each(function() {
    var speed = $(this).is('label') ? 0 : global_speed;

    if (show) {
      speed === 0 ? $(this).show() : $(this).slideDown(speed)
      $(this).find('input, select, textarea').removeAttr('data-abide-ignore')
    } else {
      speed === 0 ? $(this).hide() : $(this).slideUp(speed)
      $(this).find('input, select, textarea').attr('data-abide-ignore', 'true')
    }
  });
}

$(document).on('turbolinks:before-cache', function() {
  if ($('#start_end_date').datepicker().data('datepicker')) {
    $('#start_end_date').datepicker().data('datepicker').destroy();
  }
});

$(document).on('turbolinks:load', function() {
  Foundation.Abide.defaults.validators['greater_than'] = greaterThanValidator;

  $(document).foundation()
  $('.tooltip').tooltipster({
    theme: 'tooltipster-light'
  });
  
  $('#start_end_date').removeData('datepicker');
  $('#start_end_date').datepicker({
    language: 'en', 
    range: false, 
    toggleSelected: true,
    multipleDatesSeparator: ' - ',
    autoClose: true,
    onSelect: (formattedDate, date, inst) => {
      let dates = formattedDate.split(' - ')
      if (dates.length !== new Set(dates).size) {
        $('#item_start_date').val(dates[0])
        $('#item_end_date').val('')
        inst.$el.val(dates[0])
      } else {
        $('#item_start_date').val(dates[0])
        dates[1] ? $('#item_end_date').val(dates[1]) : $('#item_end_date').val('')
      }
    }
  });

  $('#item_repeat').on('change', function() {
    if ($(this).is(":checked")) {
      $('#start_end_date').attr('placeholder', 'MM/DD/YYYY - MM/DD/YYYY').datepicker().data('datepicker').update({
        range: true, 
        toggleSelected: false,
      }).clear()
    } else {
      $('#start_end_date').attr('placeholder', 'MM/DD/YYYY').datepicker().data('datepicker').update({
        range: false, 
        toggleSelected: true,
      }).clear()
    }
  });

  $('input[type="checkbox"].toggle-fields, select.toggle-fields').each(function() {
    toggleHiddenField($(this), 0);
  });
  
  $('body').on('change', 'input[type="checkbox"].toggle-fields, select.toggle-fields', function() {
    toggleHiddenField($(this));
  });
});

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
