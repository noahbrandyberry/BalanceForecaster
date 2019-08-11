BF.items = {
    init: () => {
        BF.items.handlers.show_past_change()
        BF.items.handlers.repeat_change()
        BF.items.initDatepicker()
    },
    handlers: {
        show_past_change: () => {
            $('#show_past').on('change', function() {
                var cookie_name = $(this).data('cookie')
                if ($(this).is(":checked")) {
                    Cookies.set(cookie_name, true);
                } else {
                    Cookies.set(cookie_name, false);
                }
            });
        },
        repeat_change: () => {
            $('#item_repeat').on('change', function() {
                if ($(this).is(":checked")) {
                    $('#start_end_date').attr('placeholder', 'YYYY/MM/DD - YYYY/MM/DD').datepicker().data('datepicker').update({
                        range: true, 
                        toggleSelected: false,
                    }).clear()
                } else {
                    $('#start_end_date').attr('placeholder', 'YYYY/MM/DD').datepicker().data('datepicker').update({
                        range: false, 
                        toggleSelected: true,
                    }).clear()
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