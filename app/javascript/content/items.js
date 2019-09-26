BF.items = {
    init: () => {
        BF.items.handlers.showPastChange()
        BF.items.handlers.repeatChange()
        BF.items.handlers.forecastTableHover()
        BF.items.handlers.forecastTableClick()
        BF.items.handlers.forecastTableActionClick()
        BF.items.handlers.itemsTableClick()
        BF.items.initDatepicker()
        BF.items.initForecastTables()
    },
    handlers: {
        showPastChange: () => {
            $('#show_past').on('change', function() {
                var cookie_name = $(this).data('cookie')
                if ($(this).is(":checked")) {
                    Cookies.set(cookie_name, true);
                } else {
                    Cookies.set(cookie_name, false);
                }
            });
        },
        repeatChange: () => {
            $('#item_repeat').on('change', function() {
                if ($(this).is(":checked")) {
                    var datepicker = $('#start_end_date').attr('placeholder', 'YYYY/MM/DD - YYYY/MM/DD').datepicker().data('datepicker').update({
                        range: true, 
                        toggleSelected: false,
                    })
                } else {
                    var datepicker = $('#start_end_date').attr('placeholder', 'YYYY/MM/DD').datepicker().data('datepicker').update({
                        range: false, 
                        toggleSelected: true,
                    })
                }

                datepicker.selectDate(datepicker.selectedDates)
            });
        },
        forecastTableActionClick: () => {
            $('table.forecast-table tbody').on('click', 'tr .row-actions', function(){
                var date = moment($(this).closest('tr').data('date'));
                var form = $('#createItemModal').find('form');
                form.find('#start_end_date').datepicker().data('datepicker').selectDate([date.toDate()])

                $('#createItemModal').foundation('open');
            });
        },
        forecastTableHover: () => {
            $('table.forecast-table tbody').on('mousemove', 'tr', function(event){
                if (!$(event.target).hasClass('row-actions') && $(event.target).closest('.row-actions').length === 0) {
                    var height = $(this).height()/2;
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
    
            $('body').on('mousemove', function(event){
                if ($(event.target).closest('table.forecast-table tbody').length === 0) {
                    $('.show-actions').removeClass('show-actions');
                }
            });
        },
        forecastTableClick: () => {
            $('table.forecast-table tbody').on('click', 'tr', function(event){
                if (!$(event.target).hasClass('row-actions') && $(event.target).closest('.row-actions').length === 0) {
                    var id = $(this).data('id');
                    var date = $(this).data('date');
                    $.get(`items/${id}/edit_occurrence/${date}`);
                }
            });
        },
        itemsTableClick: () => {
            $('table.data-table.items-table tbody').on('click', 'tr', function(event){
                if (!$(event.target).hasClass('button') && $(event.target).closest('.button').length === 0) {
                    var id = $(this).data('id');
                    var date = $(this).data('date');
                    $.get(`items/${id}/edit`);
                }
            });
        }
    },
    initDatepicker: () => {
        $('#start_end_date').removeData('datepicker');
        if ($('#item_repeat').is(":checked")) {
            var datepicker = $('#start_end_date').datepicker({
                language: 'en', 
                dateFormat: 'yyyy/mm/dd',
                range: true, 
                toggleSelected: false,
                multipleDatesSeparator: ' - ',
                autoClose: true,
                onSelect: BF.items.datepickerValueChange
            }).data('datepicker');

            if ($('#item_start_date').val()) {
                var dates = [moment($('#item_start_date').val()).toDate()]
                if ($('#item_end_date').val()) {
                    dates.push(moment($('#item_end_date').val()).toDate())
                } else {
                    dates.push(moment($('#item_start_date').val()).toDate())
                }
                datepicker.selectDate(dates);
            }
        } else {
            var datepicker = $('#start_end_date').datepicker({
                language: 'en', 
                dateFormat: 'yyyy/mm/dd',
                range: false, 
                toggleSelected: true,
                multipleDatesSeparator: ' - ',
                autoClose: true,
                onSelect: BF.items.datepickerValueChange
            }).data('datepicker');

            if ($('#item_start_date').val()) {
                var date = moment($('#item_start_date').val()).toDate();

                datepicker.selectDate(date);
            }
        }
    },
    initForecastTables: () => {
        $('table.forecast-table').DataTable({
            paging: false,
            ordering: false,
            info: false,
            autoWidth: false,
            columnDefs: [
                { width: "50px", targets: 0 }
            ]
        });
    },
    datepickerValueChange: (formattedDate, date, inst) => {
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
}