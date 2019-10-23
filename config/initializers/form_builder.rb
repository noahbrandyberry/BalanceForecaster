class CustomFormBuilder < ActionView::Helpers::FormBuilder
    def switch(attribute_name, *args, **object)
        object[:id] = object[:id] ? object[:id] : "#{options[:prepend_id]}#{object_name}_#{attribute_name}"
        object[:class] = object[:class] ? "#{object[:class]} switch-input" : "switch-input"

        @template.content_tag(:div,
            check_box(attribute_name, *args, **object) + label(attribute_name, @template.content_tag(:span, 'Yes', class: 'switch-active', aria: {hidden: true}) + @template.content_tag(:span, 'No', class: 'switch-inactive', aria: {hidden: true}), class: "switch-paddle"), 
            class: 'switch large'
        )
    end

    def text_field(attribute_name, *args, **object)
        object[:id] = object[:id] ? object[:id] : "#{options[:prepend_id]}#{object_name}_#{attribute_name}"

        super(attribute_name, *args, **object) + error_message(attribute_name, args, object)
    end

    def number_field(attribute_name, *args, **object)
        object[:id] = object[:id] ? object[:id] : "#{options[:prepend_id]}#{object_name}_#{attribute_name}"

        super(attribute_name, *args, **object) + error_message(attribute_name, args, object)
    end

    def email_field(attribute_name, *args, **object)
        object[:field_type] = 'email'
        object[:id] = object[:id] ? object[:id] : "#{options[:prepend_id]}#{object_name}_#{attribute_name}"

        super(attribute_name, *args, **object) + error_message(attribute_name, args, object)
    end

    def date_field(attribute_name, *args, **object)
        object[:id] = object[:id] ? object[:id] : "#{options[:prepend_id]}#{object_name}_#{attribute_name}"

        super(attribute_name, *args, **object) + error_message(attribute_name, args, object)
    end

    def password_field(attribute_name, *args, **object)
        object[:id] = object[:id] ? object[:id] : "#{options[:prepend_id]}#{object_name}_#{attribute_name}"

        super(attribute_name, *args, **object) + error_message(attribute_name, args, object)
    end

    def hidden_field(attribute_name, *args, **object)
        object[:id] = object[:id] ? object[:id] : "#{options[:prepend_id]}#{object_name}_#{attribute_name}"

        super(attribute_name, *args, **object)
    end

    def select(attribute_name, choices, options = {}, **object)
        object[:id] = object[:id] ? object[:id] : "#{options[:prepend_id]}#{object_name}_#{attribute_name}"

        super(attribute_name, choices, options, **object) + error_message(attribute_name, [], object)
    end

    def label(attribute_name, *args, **object)
        object[:for] = object[:for] ? object[:for] : "#{options[:prepend_id]}#{object_name}_#{attribute_name}"

        super(attribute_name, *args, **object)
    end

    def error_message(attribute_name, args, object)
        error_message = ''
        if object[:data].try(:[], :equalto)
            equalto_name = object[:data][:equalto].sub!(object_name.to_s, "")
            error_message = @template.content_tag(:p, "#{attribute_name.to_s.humanize} doesn't match #{equalto_name.humanize}", class: 'form-error')
        elsif object[:data].try(:[], :validator) === 'greater_than' && object[:data].try(:[], :greater_than)
            error_message = @template.content_tag(:p, "#{attribute_name.to_s.humanize} must be greater than #{object[:data][:greater_than]}", class: 'form-error')
        elsif object[:field_type] === 'email'
            error_message = @template.content_tag(:p, "#{attribute_name.to_s.humanize} is invalid", class: 'form-error')
        elsif object[:required]
            error_message = @template.content_tag(:p, "#{attribute_name.to_s.humanize} can't be blank", class: 'form-error')
        end
        
        error_message
    end
end

ActionView::Base.default_form_builder = CustomFormBuilder
