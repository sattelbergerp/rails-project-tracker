function loadTasksIndex(filter){
  $.get('/tasks.json?filter='+filter, function(data){
    $('#tasks-list').text('');
    data.forEach(function(taskData){
      var task = new Task(taskData);
      $('#tasks-list').append(task.buildHTML());
    });
  });
}

function Task(data){
  this.data = data;
}

Task.prototype.daysTillCompleteBy = function(){
  return -msToDay(Date.now() - new Date(this.data.complete_by).getTime());
}

Task.prototype.formattedCompleteBy = function(){
  var days = this.daysTillCompleteBy();
  var label = Math.abs(days) + (Math.abs(days)!=1 ? " days" : " day");
  if(days > 0)return "in " + label;
  if(days < 0)return label + ' ago';
  return 'today';
}

Task.prototype.classes = function(){
  var classes = 'list-group-item';
  if(this.data.completed){
    classes+= ' task-completed';
  }else if(this.data.complete_by){
    if(this.daysTillCompleteBy() < 0)classes+= ' task-overdue';
    if(this.daysTillCompleteBy() == 0)classes+= ' task-warning';
  }
  return classes;
}

Task.prototype.buildHTML = function(){
  var html = '<a class="'+this.classes()+'" href="'+this.data.html_url+'">';
  html += this.data.name;
  if(this.data.complete_by)html += '<span class="complete-by">'+this.formattedCompleteBy()+'</span>';
  return html + '</a>';
}
