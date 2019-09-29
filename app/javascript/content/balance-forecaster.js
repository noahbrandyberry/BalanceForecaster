window.BF = {
    init: () => {
        $(document).foundation()

        BF.handlers.hiddenFields()
        BF.initHiddenFields()
        BF.initAbideValidators()
        BF.initTooltips()
        BF.initViews()
        BF.initTables()
    },
    destroy: () => {
        if ($('#start_end_date').datepicker().data('datepicker')) {
            $('#start_end_date').datepicker().data('datepicker').destroy();
        }

        var dataTable = $('.data-table').DataTable();

        if (dataTable !== null) {
            dataTable.destroy();
            dataTable = null;
        }
    },
    handlers: {
        hiddenFields: () => {
            $('body').on('change', 'input[type="checkbox"].toggle-fields, select.toggle-fields', function() {
                BF.toggleHiddenFields($(this));
            });
        }
    },
    initHiddenFields: () => {
        $('input[type="checkbox"].toggle-fields, select.toggle-fields').each(function() {
            BF.toggleHiddenFields($(this), 0);
        });
    },
    initAbideValidators: () => {
        Foundation.Abide.defaults.validators['greater_than'] = BF.greaterThanValidator;
    },
    initTooltips: () => {
        $('.tooltip').tooltipster({
            theme: 'tooltipster-light'
        });
    },
    toggleHiddenFields: (e, speed = 500) => {
        if (e.is('select')) {
            var toggleable_fields = {};
            var data = e.data();
        
            for (var property in data) {
                if (data.hasOwnProperty(property) && property.startsWith('toggle')) {
                    toggleable_fields[property.substr(6).replace( /([a-z])([A-Z])/g, '$1-$2' ).toLowerCase()] = data[property];
                }
            }
        
            var true_ids = toggleable_fields[e.val()]
            delete toggleable_fields[e.val()]
            var false_ids = Object.values(toggleable_fields).join(' ');
            
            true_ids = true_ids ? "#" + true_ids.split(' ').join(', #') : null;
            false_ids = false_ids ? "#" + false_ids.split(' ').join(', #') : null;
        
            BF.toggleField(true_ids, true, speed, e.closest('.reveal, body'))
            BF.toggleField(false_ids, false, speed, e.closest('.reveal, body'))
        } else if (e.is('input[type="checkbox"]')) {
            var true_ids = e.data('toggle-true') ? "#" + e.data('toggle-true').split(' ').join(', #') : null;
            var false_ids = e.data('toggle-false') ? "#" + e.data('toggle-false').split(' ').join(', #') : null;
            
            BF.toggleField(true_ids, e.is(":checked"), speed, e.closest('.reveal, body'))
            BF.toggleField(false_ids, !e.is(":checked"), speed, e.closest('.reveal, body'))
        }
    },
    toggleField: (ids, show, global_speed, form) => {
        form.find(ids).each(function() {
            var speed = $(this).is('label') ? 0 : global_speed;
        
            if (show) {
            speed === 0 ? $(this).show() : $(this).slideDown(speed)
            $(this).find('input, select, textarea').removeAttr('data-abide-ignore')
            } else {
            speed === 0 ? $(this).hide() : $(this).slideUp(speed)
            $(this).find('input, select, textarea').attr('data-abide-ignore', 'true')
            }
        });
    },
    greaterThanValidator: ($el, required, parent) => {
        if (!required) return true;
        var from = $el.data('greater-than');
        var to = $el.val();
        
        return (parseInt(to) > parseInt(from));
    },
    initTables: () => {
        $('table.data-table').DataTable({
            paging: false,
            info: false,
            autoWidth: false,
            columnDefs: [
                { width: "50px", targets: 0 }
            ]
        });

        var left_header = $('table.data-table').closest('.dataTables_wrapper').children('.row:first-child').children('.cell:first-child');

        $('.data-table-left-header').appendTo(left_header);
    },
    initViews: () => {
        let group = $('body').data('group');
        let view = $('body').data('view');

        if (BF[group]) {
            BF[group].init();
            if (BF[group].views && BF[group].views[view]) BF[group].views[view];
        }
    }
};
