BF.items = {
  init: () => {
    BF.items.initDatepicker($('#createItemModal'))
    BF.items.initForecastTables()
    BF.items.handlers.showPastChange()
    BF.items.handlers.forecastTableHover()
    BF.items.handlers.forecastTableClick()
    BF.items.handlers.forecastTableActionClick()
    BF.items.handlers.forecastTableScroll()
    BF.items.handlers.refreshForecastTable()
    BF.items.handlers.itemsTableClick()
  },
  handlers: {
    showPastChange: () => {
      $('#show_past').on('change', function () {
        var cookie_name = $(this).data('cookie')
        if ($(this).is(":checked")) {
          Cookies.set(cookie_name, true);
        } else {
          Cookies.set(cookie_name, false);
        }
      });
    },
    forecastTableActionClick: () => {
      $('table.forecast-table tbody').on('click', 'tr .row-actions', function () {
        var date = moment($(this).closest('tr').data('date'));
        var form = $('#createItemModal').find('form');
        form.find('#new_item_start_date').datepicker().data('datepicker').selectDate([date.toDate()])

        $('#createItemModal').foundation('open');
      });
    },
    forecastTableHover: () => {
      $('table.forecast-table tbody').on('mousemove', 'tr', function (event) {
        if (!$(event.target).hasClass('row-actions') && $(event.target).closest('.row-actions').length === 0) {
          var height = $(this).height() / 2;
          $('.show-actions').removeClass('show-actions');
          $('.is-hovered').removeClass('is-hovered');
          $(this).addClass('is-hovered')

          if (event.offsetY > height) {
            $(this).next().addClass('show-actions')
          } else {
            $(this).addClass('show-actions')
          }
        }
      });

      $('body').on('mousemove', function (event) {
        if ($(event.target).closest('table.forecast-table tbody').length === 0) {
          $('.show-actions').removeClass('show-actions');
        }
      });
    },
    forecastTableClick: () => {
      $('table.forecast-table tbody').on('click', 'tr', function (event) {
        if (!$(event.target).hasClass('row-actions') && $(event.target).closest('.row-actions').length === 0) {
          var id = $(this).data('id');
          var date = $(this).data('date');
          $.get(`items/${id}/edit_occurrence/${date}`);
        }
      });
    },
    forecastTableScroll: () => {
      BF.items.lastScrollTop = 0;

      $('.dataTables_scrollBody').on('scroll', function (event) {
        const element = event.target;
        const firstDate = $('.forecast-table').attr('data-first-date');
        if (!BF.items.forecast_refreshing) {

          if (element.scrollHeight - element.scrollTop <= element.clientHeight + 200 && element.scrollTop > BF.items.lastScrollTop) {
            BF.items.scrollForecastDown()
          } else if (element.scrollTop < 200 && element.scrollTop < BF.items.lastScrollTop && BF.items.forecast_dates.start.isAfter(firstDate, 'day')) {
            BF.items.scrollForecastUp()
          }
        }

        BF.items.lastScrollTop = element.scrollTop <= 0 ? 0 : element.scrollTop;
      });
    },
    previousOccurrenceClick: () => {
      $('#editOccurrenceModal #previous-occurrences tbody').on('click', 'tr', function (event) {
        $('#editOccurrenceModal').foundation('close');
        var id = $(this).data('id');
        var date = $(this).data('date');
        $.get(`items/${id}/edit_occurrence/${date}`);
      });
    },
    refreshForecastTable: () => {
      $('body').on('click', '#refresh-table', function () {
        var scrollTop = $('.dataTables_scrollBody').scrollTop();
        $('.forecast-table').DataTable().ajax.reload(function () {
          $('.dataTables_scrollBody').scrollTop(scrollTop)
        });
      });
    },
    itemsTableClick: () => {
      $('table.data-table.items-table tbody').on('click', 'tr', function (event) {
        if (!$(event.target).hasClass('button') && $(event.target).closest('.button').length === 0) {
          var id = $(this).data('id');
          var date = $(this).data('date');
          $.get(`items/${id}/edit`);
        }
      });
    }
  },
  initDatepicker: (parent = $('.reveal')) => {
    parent.find('.datepicker-field').removeData('datepicker');
    var datepickers = parent.find('.datepicker-field').datepicker({
      language: 'en',
      dateFormat: 'yyyy/mm/dd',
      autoClose: true
    });

    datepickers.each(function () {
      var dateString = $(this).val();
      if (dateString) {
        var date = moment(dateString);

        $(this).datepicker().data('datepicker').selectDate([date.toDate()])
      }
    });
  },
  scrollForecastUp: () => {
    console.log('up')
    BF.items.forecast_dates.start.subtract(1, 'months');
    BF.items.forecast_dates.end.subtract(1, 'months');

    $('.forecast-table').DataTable().ajax.url(`forecast.json?start_date=${BF.items.forecast_dates.start.format('YYYY-MM-DD')}&end_date=${BF.items.forecast_dates.end.format('YYYY-MM-DD')}`)
    
    const scrollTop = $('.dataTables_scrollBody').scrollTop();
    BF.items.forecast_refreshing = true;

    $('.forecast-table').DataTable().ajax.reload(function () {
      var height = 0;
      $('[data-date^="' + BF.items.forecast_dates.start.clone().format('YYYY-MM') + '-"]').each(function () { height += $(this).height() });
      $('.dataTables_scrollBody').scrollTop(scrollTop + height);

      BF.items.forecast_refreshing = false
    }, false);
  },
  scrollForecastDown: () => {
    var scrollTop = $('.dataTables_scrollBody').scrollTop();
    $('[data-date^="' + BF.items.forecast_dates.start.format('YYYY-MM') + '-"]').each(function () { scrollTop -= $(this).height() });
    
    BF.items.forecast_dates.start.add(1, 'months');
    BF.items.forecast_dates.end.add(1, 'months');

    $('.forecast-table').DataTable().ajax.url(`forecast.json?start_date=${BF.items.forecast_dates.start.format('YYYY-MM-DD')}&end_date=${BF.items.forecast_dates.end.format('YYYY-MM-DD')}`)
    BF.items.forecast_refreshing = true;

    $('.forecast-table').DataTable().ajax.reload(function () {
      $('.dataTables_scrollBody').scrollTop(scrollTop);

      BF.items.forecast_refreshing = false
    }, false);
  },
  initForecastTables: () => {
    BF.items.forecast_dates = { start: moment('2019-08-01'), end: moment('2019-10-31') }
    BF.items.forecast_refreshing = false;
    $('table.forecast-table').DataTable({
      ordering: false,
      info: false,
      scrollY: 600,
      autoWidth: false,
      scroller: true,
      lengthChange: false,
      ajax: {url: `forecast.json?start_date=${BF.items.forecast_dates.start.format('YYYY-MM-DD')}&end_date=${BF.items.forecast_dates.end.format('YYYY-MM-DD')}`, dataSrc: ""},
      dom: '<"grid-x grid-margin-x"<"cell large-6"><"cell large-6"f>>t',
      createdRow: (row, data, dataIndex) => {
        if (data.is_section) {
          $(row).attr('data-date', data.date);
          $(row).addClass('group');
          $(row).children('td:eq(0)').attr('colspan', 2);
          $(row).children('td:eq(1)').hide();
        } else {
          $(row).attr('data-date', data.date);
          $(row).attr('data-id', data.item_id);
        }
      },
      columns: [
        {
          data: "is_bill",
          render: (data, type, row) => {
            if (row.is_section) {
              return `<h2>${data}</h2>`;
            }

            if (data) {
              return '<i class="far fa-minus-square fa-2x"></i>';
            } else {
              return '<i class="far fa-plus-square fa-2x"></i>'
            }
          }
        },
        {
          data: "day_of_month",
          render: (data, type, row) => {
            if (row.is_section) {
              return null;
            }
            return `<b>${row.day_of_month}</b>, ${row.day_of_week}`
          }
        },
        {
          data: "name",
          render: (data, type, row) => {
            return `${data}<div class="row-actions"><i class="fas fa-plus"></i></div>`;
          }
        },
        { data: "category" },
        { data: "amount_formatted" },
        { data: "balance_formatted" }
      ],
      columnDefs: [
        { width: "50px", targets: 0 }
      ]
    });
  }
}