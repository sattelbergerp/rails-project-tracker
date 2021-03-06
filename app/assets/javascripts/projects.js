function showProject(id){
  $('#project').hide();
  $('#project-loading').show();
  $.get('/projects/'+id + '.json', function(data){
    $('#project-messages').html('');
    $('#project-tasks').html('');
    $('#project-name').text(data.name);
    $('#project-description').text(data.description);
    data.messages.forEach(function(msg){
      $('#project-messages').append('<div class="alert alert-'+msg.message_type+'">'+msg.content+'</div>');
    });
    data.tasks.forEach(function(task){
      $('#project-tasks').append(new Task(task, id).buildHTML());
    });
    $('#next-project').data('id', data.next_id);
    $('#next-project')[data.next_id? 'show' : 'hide']();//hide if next_id is null
    $('#prev-project').data('id', data.prev_id);
    $('#prev-project')[data.prev_id? 'show' : 'hide']();//hide if prev_id is null
    $('#new-task').data('project-id', id);
    $('#edit-project').attr('href', data.links.edit);
    $('#delete-project').attr('href', data.links.self);
    $('#project-loading').hide();
    $('#project').show();
  });
}

var addTaskLoadCount = 0;

function addTaskToProjectFromFormData(projectId, formData){
  addTaskLoadCount ++;
  $('#new-task-button-icon').hide();
  $('#new-task-button-loader').show();
  $.post('/projects/'+projectId + '/tasks', formData, function(data){
    $('#project-tasks').append(new Task(data, projectId).buildHTML());
    addTaskLoadCount --;
    if(addTaskLoadCount > 0)return;
    $('#new-task-button-loader').hide();
    $('#new-task-button-icon').show();
  });
}
