var tasksIndexLoadingCount = 0;

function loadTasksIndex(filter){
  tasksIndexLoadingCount++;
  $('#tasks-list').html('<div class="loading" ></div>');
  $.get('/tasks.json?filter='+filter, function(data){
    tasksIndexLoadingCount--;
    if(tasksIndexLoadingCount > 0)return;
    $('#tasks-list').text('');
    data.forEach(function(taskData){
      var task = new Task(taskData);
      $('#tasks-list').append(task.buildHTML());
    });
  });
}

function Task(data, project_id){
  this.data = data;
  this.project_id = project_id;
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
  var html = '<li class="'+this.classes()+'">';
  html += '<a href="'+this.data.html_url+'">' + this.data.name + '</a>';
  if(this.project_id){
    html+='<a class="btn btn-danger task-list-btn" rel="nofollow" data-method="delete" href="/projects/'+this.project_id+'/tasks/'+this.data.id+'">';
    html+='<span class="glyphicon glyphicon-minus"></span></a>';
    html+='<a class="btn btn-default task-list-btn" href="/projects/'+this.project_id+'/tasks/'+this.data.id+'/edit"><span class="glyphicon glyphicon-edit"></span></a>';
  }
  if(this.data.complete_by)html += '<span class="complete-by">'+this.formattedCompleteBy()+'</span>';
  return html + '</li>';
}
