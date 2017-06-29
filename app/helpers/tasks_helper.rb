module TasksHelper
  def days_from_today(date)
    return '' if !date
    days = date.jd - Date.today.jd
    label = pluralize(days.abs, "day")
    if days < 0
      return "#{label} ago"
    elsif days > 0
      return "in #{label}"
    else
      return "today"
    end
  end

  def task_classes(task)
    classes = ['list-group-item']
    classes << 'task-completed' if task.completed
    if !task.completed && task.complete_by
      classes << 'task-overdue' if task.complete_by.jd < Date.today.jd
      classes << 'task-warning' if task.complete_by.jd == Date.today.jd
    end
    return classes
  end

  def task_form(project, task)
    if project
      return form_for [project, task] {|f| yield(f)}
    else
      return form_for [task] {|f| yield(f)}
    end
  end
end
