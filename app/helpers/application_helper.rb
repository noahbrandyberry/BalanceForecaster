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
end
