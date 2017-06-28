module ApplicationHelper
  def header_link(name, link)
    classes=''
    classes += 'active' if current_page?(link)
    content_tag :li, class: classes do
      link_to name, link
    end
  end
end
