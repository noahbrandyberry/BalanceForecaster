module ApplicationHelper
    def title
        if content_for?(:title)
            content_for :title
        else
            if I18n.exists?("#{ controller_path.tr('/', '.') }.#{ action_name }.title")
                t("#{ controller_path.tr('/', '.') }.#{ action_name }.title") + " - " + t("site_name")
            else
                t("site_name")
            end
        end
    end

    def meta_tag(tag, text)
        content_for :"meta_#{tag}", text
    end

    def yield_meta_tag(tag, default_text='')
        content_for?(:"meta_#{tag}") ? content_for(:"meta_#{tag}") : default_text
    end

    def show_past? account, items
        return cookies["show_past_#{account.id}"] === "true" if ["true", "false"].include? cookies["show_past_#{account.id}"]
        items.length === 0
    end
end
