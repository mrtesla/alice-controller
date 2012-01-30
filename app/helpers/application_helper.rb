module ApplicationHelper

  def breadcrumb(items)
    items.unshift(['Home', root_path])

    last_item = items.pop

    items.map! do |(title, url)|
      link = link_to(title, url)
      "<li>#{link} <span class=\"divider\">/</span></li>"
    end

    if last_item
      name = last_item.first
      items << "<li class=\"active\">#{name}</li>"
    end

    raw "<ul class=\"breadcrumb\">" + items.join(' ') + "</ul>"
  end

  def flash_messages
    html = ""

    %w( success error warning notice ).each do |key|
      value = flash[key.to_sym]
      key   = 'info' if key == 'notice'

      if value
        html << "<div data-alert=\"alert\" class=\"alert-message #{key}\"><a class=\"close\" href=\"#\">&times;</a><p>#{h value}</p></div>"
      end
    end

    raw html
  end

end
